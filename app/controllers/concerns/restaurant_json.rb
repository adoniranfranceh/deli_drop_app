module RestaurantJson
  extend ActiveSupport::Concern
  include ProductJson

  def restaurant_json(restaurant)
    {
      id: restaurant.id,
      name: restaurant.name,
      logo: restaurant.image,
      description: restaurant.description,
      categories: categories_json(restaurant)
    }
  end

  private

  def categories_json(restaurant)
    restaurant.categories
              .where(id: restaurant.products.select(:category_id).distinct)
              .includes(products: [ :category, { modifier_groups: :modifiers } ])
              .map { |category| category_json(category) }
  end

  def category_json(category)
    {
      id: category.id,
      name: category.name,
      products: category.products.active.map { |product| product_json(product) }
    }
  end
end
