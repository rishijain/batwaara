class Bill < ActiveRecord::Base
  include AASM

  aasm do

    state :draft, initial: true
    state :approved

    event :approve do
      transitions from: :draft, to: :approved
    end

  end

  has_many :transactions
  belongs_to :event

  def members
    User.find(member_ids)
  end
end
