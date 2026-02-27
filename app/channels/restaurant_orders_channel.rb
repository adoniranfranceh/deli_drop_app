class RestaurantOrdersChannel < ApplicationCable::Channel
  def subscribed
    restaurant = restaurant_user&.restaurant

    if restaurant
      stream_for restaurant
    else
      reject
    end
  end
end
