class Restaurant < ApplicationRecord
  belongs_to :restaurant_user

  has_many :categories
  has_many :products
  has_many :orders

  validates :name, :culinary_style, :description, :image, :phone, presence: true
  validates :restaurant_user_id, uniqueness: true

  enum :culinary_style, { acai: 0, brazilian: 1, italian: 2, japanese: 3, mexican: 4,
                        burgers: 5, pizza: 6, healthy: 7, vegetarian: 8, sweets: 9,
                        snacks: 10, barbecue: 11, seafood: 12, coffee_shop: 13, ice_cream: 14 }

  after_create :add_default_categories

   DEFAULT_CATEGORIES = [
    "Bebidas",
    "Combos",
    "Pratos Principais",
    "Sobremesas"
  ].freeze

  def add_default_categories
    DEFAULT_CATEGORIES.each do |name|
      categories.create!(name:)
    end
  end

  # Days: 0=Sunday, 1=Monday, ..., 6=Saturday
  def open_now?
    return true if opening_time.nil? || closing_time.nil? || open_days.blank?

    now = Time.current
    return false unless open_days.include?(now.wday)

    current_time = now.strftime("%H:%M")
    open = opening_time.strftime("%H:%M")
    close = closing_time.strftime("%H:%M")

    if open <= close
      current_time >= open && current_time < close
    else
      current_time >= open || current_time < close
    end
  end
end
