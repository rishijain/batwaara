class UsersController < ApplicationController
  before_filter :authenticate_user!

  def my_account
    @from_ledger = Ledger.where(from_user_id: current_user.id)
    @to_ledger = Ledger.where(to_user_id: current_user.id)
  end
end
