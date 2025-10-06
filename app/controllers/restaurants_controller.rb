class RestaurantsController < ApplicationController
  skip_before_action :restaurant_registered?, only: %i[new]
  before_action :set_restaurant, only: %i[edit]

  def edit
    authorize @restaurant
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id]) if params[:id]
  end
end
