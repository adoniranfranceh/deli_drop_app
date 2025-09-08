class Modifier < ApplicationRecord
  belongs_to :modifier_group

  validates :name, :base_price, :image, presence: true
end
