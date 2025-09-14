class Category < ApplicationRecord
  belongs_to :restaurant
  has_many :products

  scope :with_products_stats, -> {
    left_joins(:products)
      .select(
        "categories.id,
         categories.name,
         COUNT(products.id) AS products_count,
         SUM(CASE WHEN products.status = #{Product.statuses[:active]} THEN 1 ELSE 0 END) AS actived_products_count,
         COALESCE(AVG(products.base_price), 0) AS average_price"
      )
      .group("categories.id")
  }

  validates :name, presence: true
end
