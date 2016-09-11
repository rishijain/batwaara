require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should return all settlement bills where I was paid" do
    bill = Bill.new
    bill.event = events(:lunch)
    bill.user_ids = [users(:amar).id]
    bill.amount = 200
    bill.paid_to_id = users(:akbar).id
    bill.save

    users(:akbar).reload
    assert users(:akbar).settlement_bills.first.id == bill.id
  end
end
