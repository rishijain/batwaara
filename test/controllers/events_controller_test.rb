require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should get index" do
    bill = Event.create(name: "first event")
    sign_in users(:amar)
    get :index
    assert_response :success
  end

  test "should create an event" do
    sign_in users(:amar)
    assert_difference('Event.count') do
      post :create, {event: {name: "new event"}}
    end
    assert_redirected_to events_path
  end
end
