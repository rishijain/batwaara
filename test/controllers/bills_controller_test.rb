require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  #

  test "should get index" do
    bill = Bill.create(event_id: events(:lunch).id, created_by_id: users(:amar).id, amount: 100)
    [users(:amar), users(:akbar), users(:anthony)].each do |user|
      BillUser.create(bill_id: bill.id, user_id: user.id)
    end
    sign_in_as users(:amar)
    get :index
    #get bills_url
    assert_response :success
  end
end
