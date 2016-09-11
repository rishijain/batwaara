class SettlementBillCalculator
  include Ledger::Helper

  def initialize(bill)
    @bill = bill
  end

  def manage
    @bill.transactions.each do |d|
      l = find_ledger_object(d.user_id, @bill.paid_to_id)
      if l.from_user_id == d.user_id
        l.amount = l.amount - d.amount_paid
      else
        l.amount = l.amount + d.amount_paid
      end
      l.save
    end
  end

end
