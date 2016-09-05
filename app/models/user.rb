class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :transactions
end
