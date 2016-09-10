class BillsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_bill, only: [:edit, :update, :destroy, :transactions, :finalise_bill, :approve_bill]

  def index
    @bills = (current_user.bills + Bill.where(created_by: current_user)).uniq
  end

  def new
    @bill = Bill.new
  end

  def create
    @bill = Bill.new bill_params
    if @bill.save
      redirect_to transactions_bill_path(@bill)
    else
      render 'new'
    end
  end

  def edit
  end

  def transactions
    @bill.user_ids.each do |user_id|
      @bill.transactions.find_or_initialize_by(user_id: user_id)
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
      flash[:success] = 'Bill successfulyy approved.'
      redirect_to bills_path
    else
      flash[:danger] = @bill.errors.messages.values[0].join(',')
      render 'edit'
    end
  end

  private

  def get_bill
    @bill = Bill.find params[:id]
  end

  def bill_params
    params.fetch(:bill, {}).permit(:event_id, :amount, :created_by_id, user_ids: [], :transactions_attributes => [:amount_paid, :user_id, :id])
  end

end
