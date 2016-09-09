class Bill < ActiveRecord::Base
  include AASM

  has_many :transactions
  has_many :users, through: :bill_users
  has_many :bill_users
  belongs_to :event
  belongs_to :created_by, class_name: User

  accepts_nested_attributes_for :transactions

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

end
