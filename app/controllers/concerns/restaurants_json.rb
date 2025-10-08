module RestaurantsJson
  extend ActiveSupport::Concern
  include RestaurantJson

  def restaurants_json(full: false, collection: nil)
    collection ||= Restaurant.all

    collection.map do |restaurant|
      if full
        restaurant_json(restaurant)
      else
        {
          id: restaurant.id,
          name: restaurant.name,
          description: restaurant.description,
          logo: restaurant.image
        }
      end
    end
  end
end
