require 'test_helper'

class BillTest < ActiveSupport::TestCase
  test "should return true for settlement event" do
    bill = Bill.new
    bill.event_id = events(:settlement).id
    assert bill.event_is_settlement? == true
  end

  test "paid_to should return user object" do
    bill = Bill.new
    bill.paid_to_id = users(:amar).id
    assert bill.paid_to == users(:amar)
  end

end
