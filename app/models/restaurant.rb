class Restaurant < ApplicationRecord
  belongs_to :restaurant_user

  has_many :categories

  validates :name, :culinary_style, :description, :image, :phone, presence: true
  validates :restaurant_user_id, uniqueness: true

  enum :culinary_style, { acai: 0, brazilian: 1, italian: 2, japanese: 3, mexican: 4,
                        burgers: 5, pizza: 6, healthy: 7, vegetarian: 8, sweets: 9,
                        snacks: 10, barbecue: 11, seafood: 12, coffee_shop: 13, ice_cream: 14 }
end
