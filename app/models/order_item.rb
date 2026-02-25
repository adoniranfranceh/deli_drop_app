class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true
  has_many :order_item_modifiers, dependent: :destroy

  accepts_nested_attributes_for :order_item_modifiers

  validates :product_name, :unit_price, :quantity, :total_price, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, :total_price, numericality: { greater_than_or_equal_to: 0 }
end
