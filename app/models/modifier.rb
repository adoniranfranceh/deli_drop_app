class Modifier < ApplicationRecord
  belongs_to :modifier_group

  validates :name, presence: true
end
