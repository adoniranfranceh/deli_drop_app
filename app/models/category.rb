class Category < ApplicationRecord
  belongs_to :restaurant
  has_many :products

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

  validates :name, presence: true
end
