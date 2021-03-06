class Bill < ActiveRecord::Base
  include AASM

  has_many :transactions, dependent: :destroy
  has_many :users, through: :bill_users
  has_many :bill_users
  belongs_to :event
  belongs_to :created_by, class_name: User

  accepts_nested_attributes_for :transactions

  validates :event_id, presence: true
  validates :user_ids, presence: true, if: -> {event_id != Event.find_by(name: 'Settlement').id}
  validates :amount, presence: true
  validates :paid_to_id, presence: true, if: -> {event_id == Event.find_by(name: 'Settlement').id}
  validate :validate_bill_amount, if: -> {aasm_state_changed? && approved?}

  aasm do

    state :draft, initial: true
    state :approved

    event :approve do
      transitions from: :draft, to: :approved
    end

  end

  def paid_to
    paid_to_id ? User.find(paid_to_id) : nil
  end

  def validate_bill_amount
    if !event_is_settlement? && transactions.sum(:amount_paid) != amount
      errors.add(:amount, "Total transaction value should be equal to bill amount.")
    end
  end

  def event_is_settlement?
    Event.where(id: event_id).first.try(:name) == 'Settlement'
  end

end
