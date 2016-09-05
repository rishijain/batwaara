module UsersHelper

  def from_ledger_modifier(obj)
    if obj.amount < 0
      "#{obj.to_user.name} owes you Rs#{obj.amount.abs}"
    elsif obj.amount > 0
      "You owe #{obj.to_user.name} Rs#{obj.amount.abs}"
    end
  end

  def to_ledger_modifier(obj)
    if obj.amount < 0
      "You owe #{obj.from_user.name} Rs#{obj.amount.abs}"
    elsif obj.amount > 0
      "#{obj.from_user.name} owes you Rs#{obj.amount.abs}"
    end
  end
end
