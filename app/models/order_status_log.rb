class OrderStatusLog < ApplicationRecord
  belongs_to :order

  validates :to_status, :changed_by, presence: true
end
