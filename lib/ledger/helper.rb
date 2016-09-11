module Ledger::Helper

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
    l
  end

end
