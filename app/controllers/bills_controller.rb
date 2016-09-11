class BillsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_bill, only: [:edit, :update, :destroy, :transactions, :finalise_bill, :approve_bill]

  def index
    @bills = (current_user.bills + Bill.where(created_by: current_user) + current_user.settlement_bills).uniq
  end

  def new
    @bill = Bill.new
  end

  def create
    @bill = Bill.new bill_params
    if @bill.save
      if @bill.event_is_settlement?
        redirect_to bills_path
      else
        redirect_to transactions_bill_path(@bill)
      end
    else
      render 'new'
    end
  end

  def edit
  end

  def transactions
    if @bill.event_is_settlement?
      flash[:info] = 'Transaction page does not exist for settlement bills.'
      redirect_to bills_path
    end
    @bill.user_ids.each do |user_id|
      @bill.transactions.find_or_create_by(user_id: user_id)
    end
  end

  def update
    @bill.attributes = bill_params
    if @bill.save
      redirect_to bills_path
    else
      render 'transactions'
    end
  end

  def destroy
    if @bill.approved?
      flash[:danger] = 'Bill cant be deleted once it is approved.'
    else
      @bill.destroy
      flash[:success] = 'Bill was successfully destroyed.'
    end
    redirect_to bills_path
  end

  def approve_bill
    if @bill.approve!
      create_transactions_for_settlement_bill if @bill.event_is_settlement?
      ExpenseCalculator.new(@bill.id).manage
      flash[:success] = 'Bill successfulyy approved.'
      redirect_to bills_path
    else
      flash[:danger] = @bill.errors.messages.values[0].join(',')
      render 'edit'
    end
  end

  private

  def create_transactions_for_settlement_bill
    Transaction.create!(bill_id: @bill.id, user_id: current_user.id, amount_paid: @bill.amount)
  end

  def get_bill
    @bill = Bill.find params[:id]
  end

  def bill_params
    params.fetch(:bill, {}).permit(:event_id, :amount, :created_by_id, :paid_to_id, user_ids: [], :transactions_attributes => [:amount_paid, :user_id, :id])
  end

end
