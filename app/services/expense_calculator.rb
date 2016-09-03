class ExpenseCalculator

  def initialize(bill_id)
    @bill = Bill.find bill_id
  end

  def run
    @per_head_share = per_head_share
  end

  def calculate_individual_expenses
  end

  def per_head_share
    (@bill.amount / @bill.member_ids.count).round(2)
  end

  def total_amount_paid_by(user_id)
    @bill.transactions.where(user_id: user_id).sum(:amount_paid).round(2)
  end

  def each_member_owes
    @per_member_share = @bill.member_ids.inject({}) do |result, member_id|
      result[member_id] = total_amount_paid_by(member_id) - @per_head_share
      result
    end
  end

  def calculator
    run
    each_member_owes

    lenders = @per_member_share.select {|a,b| b < 0}
    lenders.each do |s,k|
      send_money_from(s)
=begin
      receiver = @per_member_share.select {|a,b| b != 0.0 && b >= k && !lenders.keys.include?(a)}.first #['1', 123]
      @per_member_share[receiver[0]] = (@per_member_share[receiver[0]] - k.abs).round(2)
      @per_member_share[s] = (@per_member_share[s] + k.abs).round(2)
      l = Ledger.find_or_create_by(from_user_id: s.to_i, to_user_id: receiver[0].to_i)
      l.amount = l.amount + k.abs
      l.save
=end

    end

  end

  def send_money_from(sender_id)
    return nil if @per_member_share[sender_id] == 0.0
    lenders = @per_member_share.select {|a,b| b < 0}
    receiver = @per_member_share.select {|a,b| b != 0.0 && b >= @per_member_share[sender_id] && !lenders.keys.include?(a)}.first #['1', 123]

    amount_to_transfer = [ @per_member_share[sender_id].abs, @per_member_share[receiver[0]].abs ].min
    @per_member_share[receiver[0]] = (@per_member_share[receiver[0]] - amount_to_transfer).round(2)
    @per_member_share[sender_id] = (@per_member_share[sender_id] + amount_to_transfer).round(2)

    l = Ledger.find_or_create_by(from_user_id: sender_id.to_i, to_user_id: receiver[0].to_i)
    l.amount = l.amount + amount_to_transfer
    l.save

    send_money_from(sender_id)
  end

end
