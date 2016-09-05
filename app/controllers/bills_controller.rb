class BillsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @bills = current_user.bills
  end

  def new
    @bill = Bill.new
  end

  def create
  end

end
