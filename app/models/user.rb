class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :transactions
  has_many :bills, through: :bill_users
  has_many :bill_users

  def settlement_bills
    Bill.where(paid_to_id: id)
  end
=begin
  def bills
    Bill.where("'#{id}' = ANY (member_ids)")
  end
=end

end
