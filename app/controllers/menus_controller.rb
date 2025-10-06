class MenusController < ApplicationController
  def show
    @categories = current_restaurant_user.restaurant.categories.with_products_stats
    @products = current_restaurant_user.restaurant.products.with_category_name
  end
end
