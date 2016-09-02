class Bill < ActiveRecord::Base

  has_many :transactions
  belongs_to :event

end
