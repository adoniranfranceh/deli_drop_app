class Category < ApplicationRecord
  belongs_to :restaurant
  has_many :products

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id, case_sensitive: false }

  validate :restaurant_category_limit

  scope :with_products_stats, -> {
    active_status = Product.statuses[:active]

    select_clause = sanitize_sql_array([
      "categories.id,
       categories.name,
       COUNT(products.id) AS products_count,
       SUM(CASE WHEN products.status = ? THEN 1 ELSE 0 END) AS actived_products_count,
       COALESCE(AVG(products.base_price), 0) AS average_price",
      active_status
    ])

    left_joins(:products).select(select_clause).group("categories.id")
  }

  MAX_CATEGORIES_PER_RESTAURANT = 10

  private

  def restaurant_category_limit
    return if restaurant.nil?
    return if restaurant.categories.count < MAX_CATEGORIES_PER_RESTAURANT
    errors.add(
      :base,
      I18n.t("activerecord.errors.models.category.attributes.base.max_categories",
             count: MAX_CATEGORIES_PER_RESTAURANT)
    )
  end
end
