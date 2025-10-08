module ProductsJson
  extend ActiveSupport::Concern
  include ProductJson

  def products_json(full: false, collection: nil)
    collection ||= Product.all

    collection.map do |product|
      if full
        product_json(product)
      else
        {
          id: product.id,
          restaurant_id: product.restaurant_id,
          name: product.name,
          description: product.description,
          image: product.image,
          base_price: product.base_price
        }
      end
    end
  end
end
