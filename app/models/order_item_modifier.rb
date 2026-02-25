class OrderItemModifier < ApplicationRecord
  belongs_to :order_item
  belongs_to :modifier, optional: true

  validates :group_name, :modifier_name, :unit_price, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
end
