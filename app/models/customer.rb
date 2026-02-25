class Customer < ApplicationRecord
  has_many :orders

  validates :name, :phone, presence: true
  validates :phone, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
end
