class Product < ApplicationRecord
  belongs_to :category
  belongs_to :restaurant

  has_many :modifier_groups, dependent: :destroy
  accepts_nested_attributes_for :modifier_groups, allow_destroy: true

  validates :name, :category, :base_price, :duration, :description, :status, presence: true
  validates :featured, inclusion: { in: [ true, false ] }

  enum :status, { active: 5, inactive: 10 }
end
