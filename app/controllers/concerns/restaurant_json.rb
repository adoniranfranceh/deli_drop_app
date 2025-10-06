module RestaurantJson
  extend ActiveSupport::Concern

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

  def product_json(product)
    {
      id: product.id,
      restaurant_id: product.restaurant_id,
      name: product.name,
      duration: product.duration,
      base_price: product.base_price,
      description: product.description,
      image: product.image,
      category: product.category.name,
      modifier_groups: product.modifier_groups.map { |group| modifier_group_json(group) }
    }
  end

  def modifier_group_json(group)
    {
      id: group.id,
      product_id: group.product_id,
      name: group.name,
      input_type: group.input_type,
      min: group.min,
      max: group.max,
      free_limit: group.free_limit,
      modifiers: group.modifiers.map { |modifier| modifier_json(modifier) }
    }
  end

  def modifier_json(modifier)
    {
      id: modifier.id,
      modifier_group_id: modifier.modifier_group_id,
      name: modifier.name,
      base_price: modifier.base_price,
      image: modifier.image
    }
  end
end
