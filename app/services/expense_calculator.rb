class ExpenseCalculator

  def initialize(bill_id)
    @bill = Bill.find bill_id
  end

  def manage
    @bill.event.name != 'Settlement' ? GeneralBillCalculator.new(@bill).manage : SettlementBillCalculator.new(@bill).manage
  end

end
