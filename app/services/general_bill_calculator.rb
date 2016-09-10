class GeneralBillCalculator

  def initialize(bill)
    @bill = bill
  end

  def manage
    per_head_share
    each_member_owes
    calculate
  end

  private

  def per_head_share
    @per_head_share = (@bill.amount / @bill.user_ids.count).round(2)
  end

  def each_member_owes
    @per_member_share = @bill.user_ids.inject({}) do |result, member_id|
      result[member_id] = total_amount_paid_by(member_id) - @per_head_share
      result
    end
  end

  def total_amount_paid_by(user_id)
    @bill.transactions.where(user_id: user_id).sum(:amount_paid).round(2)
  end

  def calculate
    lenders = @per_member_share.select {|a,b| b < 0}

    #iterate over people who owes money to someone
    lenders.each do |s,k|
      send_money_from(s)
    end

  end

  def send_money_from(sender_id)
    return nil if @per_member_share[sender_id] == 0.0
    lenders = @per_member_share.select {|a,b| b < 0}
    receiver = @per_member_share.select {|a,b| b != 0.0 && b >= @per_member_share[sender_id] && !lenders.keys.include?(a)}.first #['1', 123]

    amount_to_transfer = [ @per_member_share[sender_id].abs, @per_member_share[receiver[0]].abs ].min
    @per_member_share[receiver[0]] = (@per_member_share[receiver[0]] - amount_to_transfer).round(2)
    @per_member_share[sender_id] = (@per_member_share[sender_id] + amount_to_transfer).round(2)

    l = find_ledger_object(sender_id.to_i, receiver[0].to_i)
    update_ledger(l, sender_id.to_i, receiver[0].to_i, amount_to_transfer)

    send_money_from(sender_id)
  end

  def find_ledger_object(user_1_id, user_2_id)
    Ledger.find_by(from_user_id: user_1_id, to_user_id: user_2_id) ||
    Ledger.find_by(from_user_id: user_2_id, to_user_id: user_1_id) ||
    Ledger.create(from_user_id: user_1_id, to_user_id: user_2_id)
  end

  def update_ledger(l, user_1_id, user_2_id, amount_to_transfer)
    if l.from_user_id == user_1_id
      l.amount = l.amount + amount_to_transfer
    else
      l.amount = l.amount - amount_to_transfer
    end
    l.save
  end
end
