class DashboardController < ApplicationController
  def index
    @restaurant = current_restaurant_user.restaurant
  end
end
