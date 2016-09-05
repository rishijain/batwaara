class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :transactions

  def bills
    Bill.where("'#{id}' = ANY (member_ids)")
  end

end
