require 'test_helper'

class ExpenseCalculatorTest < ActiveSupport::TestCase

  def basic_users_setup
    Ledger.destroy_all
    @amar = users(:amar)
    @akbar = users(:akbar)
    @anthony = users(:anthony)
  end

  def first_bill
    bill = Bill.create(event_id: events(:lunch).id, created_by_id: @amar.id, amount: 120, user_ids: [@amar.id, @akbar.id, @anthony.id])
    Transaction.create(bill_id: bill.id, user_id: @amar.id, amount_paid: 120)
    Transaction.create(bill_id: bill.id, user_id: @akbar.id, amount_paid: 0)
    Transaction.create(bill_id: bill.id, user_id: @anthony.id, amount_paid: 0)
    bill
  end

  test "should return correct ledger entries for a single bill" do
    basic_users_setup
    bill = first_bill

    ExpenseCalculator.new(bill.id).manage
    assert Ledger.count == 2
    l = Ledger.find_by(from_user_id: @akbar.id, to_user_id: @amar.id)
    assert l.amount == 40.0
    l = Ledger.find_by(from_user_id: @anthony.id, to_user_id: @amar.id)
    assert l.amount == 40.0
  end

  test "should return correct ledger entries multiple bills" do
    basic_users_setup
    bill = first_bill

    #first bill, akbar and anthony owes 40.0  to amar
    ExpenseCalculator.new(bill.id).manage

    #second bill, amar owes 100.0 to akbar
    bill = Bill.create(event_id: events(:lunch).id, created_by_id: @amar.id, amount: 200, user_ids: [@amar.id, @akbar.id])
    Transaction.create(bill_id: bill.id, user_id: @amar.id, amount_paid: 0)
    Transaction.create(bill_id: bill.id, user_id: @akbar.id, amount_paid: 200)

    #so basically amar owes 60.0 to akbar
    #anthony owes 40 to amar

    ExpenseCalculator.new(bill.id).manage
    assert Ledger.count == 2
    l = Ledger.find_by(from_user_id: @akbar.id, to_user_id: @amar.id)
    assert l.amount == -60.0
    l = Ledger.find_by(from_user_id: @anthony.id, to_user_id: @amar.id)
    assert l.amount == 40.0
  end

  test "should return 0.0 as amount after settlement" do
    basic_users_setup
    bill = first_bill

    #first bill, akbar and anthony owes 40.0  to amar
    ExpenseCalculator.new(bill.id).manage

    bill = Bill.create(event_id: events(:settlement).id, created_by_id: @akbar.id, amount: 40.0, paid_to_id: @amar.id, user_ids: [@akbar.id])
    Transaction.create(bill_id: bill.id, user_id: @akbar.id, amount_paid: 40.0)
    ExpenseCalculator.new(bill.id).manage

    l = Ledger.find_by(from_user_id: @akbar.id, to_user_id: @amar.id)
    assert l.amount == 0.0
  end

  test "should return correct ledger entries for a single bill when bill is created by a third person" do
    basic_users_setup

    bill = Bill.create(event_id: events(:lunch).id, created_by_id: @amar.id, amount: 120, user_ids: [@akbar.id, @anthony.id])
    Transaction.create(bill_id: bill.id, user_id: @akbar.id, amount_paid: 120)
    Transaction.create(bill_id: bill.id, user_id: @anthony.id, amount_paid: 0)

    ExpenseCalculator.new(bill.id).manage
    assert Ledger.count == 1
    l = Ledger.find_by(from_user_id: @anthony.id, to_user_id: @akbar.id)
    assert l.amount == 60.0
  end
end
