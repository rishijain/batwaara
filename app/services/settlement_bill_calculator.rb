class SettlementBillCalculator

  def initialize(bill)
    @bill = bill
  end

  def manage
    @bill.transactions.each do |d|
      l = Ledger.find_or_create_by(from_user_id: d.user_id, to_user_id: @bill.paid_to_id)
      l.amount = l.amount - d.amount_paid
      l.save
    end
  end

end
