class Bill < ActiveRecord::Base
  include AASM

  has_many :transactions
  belongs_to :event

  accepts_nested_attributes_for :transactions

  before_save :strip_member_ids

  aasm do

    state :draft, initial: true
    state :approved

    event :approve do
      transitions from: :draft, to: :approved
    end

  end


  def members
    User.find(member_ids)
  end

  def paid_to
    paid_to_id ? User.find(paid_to_id) : nil
  end

  def strip_member_ids
    self.member_ids = self.member_ids.select(&:present?)
  end
end
