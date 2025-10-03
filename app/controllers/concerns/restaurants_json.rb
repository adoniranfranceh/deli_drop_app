module RestaurantsJson
  extend ActiveSupport::Concern
  include RestaurantJson

  def restaurants_json(full: false)
    restaurants = Restaurant.joins(:products).distinct.order(:id)

    restaurants.map do |restaurant|
      if full
        restaurant_json(restaurant)
      else
        {
          id: restaurant.id,
          name: restaurant.name,
          logo: restaurant.image
        }
      end
    end
  end
end
