require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  #

  test "should get index" do
    bill = Bill.create(event_id: events(:lunch).id, created_by_id: users(:amar).id, amount: 100, user_ids: [users(:amar).id, users(:anthony).id, users(:akbar).id])
    sign_in users(:amar)
    get :index
    assert_response :success
  end

  test "bill should be created and redirected to transactions page if event is not settlement" do
    sign_in users(:amar)
    assert_difference('Bill.count') do
      post :create, {bill: {event_id: events(:lunch).id, created_by_id: users(:amar).id, user_ids: [users(:anthony).id, users(:akbar).id], amount: 400.0}}
    end
    assert_redirected_to transactions_bill_path(Bill.last.id)
  end

  test "bill should be created and redirected to bills index page if event is settlement" do
    sign_in users(:amar)
    assert_difference('Bill.count') do
      post :create, {bill: {event_id: events(:settlement).id, created_by_id: users(:amar).id, user_ids: [users(:amar).id], amount: 400.0, paid_to_id: users(:anthony).id}}
    end
    assert_redirected_to bills_path
  end

  test "bill should be updated and redirected bills index page" do
    sign_in users(:amar)
    post :create, {bill: {event_id: events(:settlement).id, created_by_id: users(:amar).id, user_ids: [users(:amar).id], amount: 400.0, paid_to_id: users(:anthony).id}}
    bill = Bill.last
    patch :update, {bill: {event_id: events(:settlement).id, created_by_id: users(:amar).id, user_ids: [users(:amar).id], amount: 600.0, paid_to_id: users(:anthony).id}, id: bill.id}
    bill = Bill.last
    assert Bill.count == 1
    assert bill.amount == 600.0
    assert_redirected_to bills_path
  end

  test "bill should be approved and transaction and ledger should be created for settlement bills" do
    old_ledger_count = Ledger.count
    sign_in users(:amar)
    post :create, {bill: {event_id: events(:settlement).id, created_by_id: users(:amar).id, user_ids: [users(:amar).id], amount: 400.0, paid_to_id: users(:anthony).id}}
    bill = Bill.last
    assert_difference('Transaction.count') do
      post :approve_bill, {id: bill.id}
    end
    bill.reload
    assert Ledger.count == old_ledger_count + 1
    l = Ledger.last
    assert l.from_user_id == users(:amar).id
    assert l.to_user_id == users(:anthony).id
    assert l.amount == -400.0
    assert bill.aasm_state == 'approved'
    assert bill.transactions.count == 1
  end

  test "bill should be approved and ledger should be created for non-settlement bills" do
    bill = Bill.create(event_id: events(:lunch).id, created_by_id: users(:amar).id, amount: 120, user_ids: [users(:amar).id, users(:anthony).id, users(:akbar).id])

    Transaction.create(bill_id: bill.id, amount_paid: 60.0,user_id: users(:amar).id)
    Transaction.create(bill_id: bill.id, amount_paid: 60.0,user_id: users(:akbar).id)
    Transaction.create(bill_id: bill.id, amount_paid: 0.0,user_id: users(:anthony).id)

    old_ledger_count = Ledger.count
    old_trasaction_count = Transaction.count

    sign_in users(:amar)
    post :approve_bill, {id: bill.id}

    bill.reload
    assert Ledger.count == old_ledger_count + 2
    assert Transaction.count == old_trasaction_count

    l = Ledger.last
    assert bill.aasm_state == 'approved'
  end

  test "user should be redirected to bills index page when trying to access transactions page for settlement bills with proper flash message" do
    sign_in users(:amar)
    post :create, {bill: {event_id: events(:settlement).id, created_by_id: users(:amar).id, user_ids: [users(:amar).id], amount: 400.0, paid_to_id: users(:anthony).id}}

    get :transactions, {id: Bill.last.id}
    assert_redirected_to bills_path
    assert_equal "Transaction page does not exist for settlement bills.", flash[:info]
  end

  test "approved bill should not be allowed to destroy, proper message should be displayed, and redirected to bills index page" do
    sign_in users(:amar)
    post :create, {bill: {event_id: events(:settlement).id, created_by_id: users(:amar).id, user_ids: [users(:amar).id], amount: 400.0, paid_to_id: users(:anthony).id}}
    post :approve_bill, {id: Bill.last.id}

    delete :destroy, {id: Bill.last.id}
    assert_redirected_to bills_path
    assert_equal "Bill cant be deleted once it is approved.", flash[:danger]
  end

  test "approved bill should be destroyed and its transactions destroyed as well, proper message should be displayed, and redirected to bills index page" do
    sign_in users(:amar)
    post :create, {bill: {event_id: events(:settlement).id, created_by_id: users(:amar).id, user_ids: [users(:amar).id], amount: 400.0, paid_to_id: users(:anthony).id}}

    delete :destroy, {id: Bill.last.id}
    assert_redirected_to bills_path
    assert_equal "Bill was successfully destroyed.", flash[:success]
  end
end
