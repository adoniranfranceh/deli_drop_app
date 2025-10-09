class Product < ApplicationRecord
  belongs_to :category
  belongs_to :restaurant

  has_many :modifier_groups, dependent: :destroy
  accepts_nested_attributes_for :modifier_groups, allow_destroy: true

  validates :name, :category, :base_price, :duration, :description, :status, presence: true
  validates :featured, inclusion: { in: [ true, false ] }

  validate :category_belongs_to_same_restaurant

  enum :status, { active: 5, inactive: 10 }

  scope :with_category_name, -> {
    joins(:category).select("products.*, categories.name AS category_name")
  }

  private

  def category_belongs_to_same_restaurant
    return if category.nil? || restaurant.nil?
    if category.restaurant_id != restaurant_id
      errors.add(:category, I18n.t("activerecord.errors.models.product.attributes.category.same_restaurant"))
    end
  end
end
