class BillsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @bills = current_user.bills
  end

  def new
    @bill = Bill.new
  end

  def create
    @bill = Bill.new bill_params
    if @bill.save
      redirect_to bills_path
    else
      render 'new'
    end
  end

  def edit
    @bill = Bill.find params[:id]
  end

  def transactions
    @bill = Bill.find params[:id]
    @bill.user_ids.each do |user_id|
      @bill.transactions.find_or_initialize_by(user_id: user_id)
    end
  end

  def update
    @bill = Bill.find params[:id]
    @bill.attributes = bill_params
    if @bill.save
      redirect_to bills_path
    else
      render 'transactions'
    end
  end

  private

  def bill_params
    params.fetch(:bill, {}).permit(:event_id, :amount, user_ids: [], :transactions_attributes => [:amount_paid, :user_id, :id])
  end

end
