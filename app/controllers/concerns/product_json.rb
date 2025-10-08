module ProductJson
  extend ActiveSupport::Concern

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
      featured: product.featured,
      modifier_groups: product.modifier_groups.map { |group| modifier_group_json(group) }
    }
  end

  private

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
