class MenusController < ApplicationController
  def show
    @categories = current_restaurant_user.restaurant.categories.with_products_stats
  end
end
