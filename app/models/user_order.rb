class UserOrder < ApplicationRecord
  has_many :post
  has_one :user
  enum status: { active: 0, ready_to_get: 1, inactive: 2 }
end
