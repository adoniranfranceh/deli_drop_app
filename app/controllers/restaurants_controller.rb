class RestaurantsController < ApplicationController
  skip_before_action :restaurant_user_signed_in?, only: %i[new]
  before_action :set_restaurant, only: %i[edit new]

  def edit; end

  def new
    redirect_to edit_restaurant_path(@restaurant),
                alert: I18n.t("restaurants.new.you_already_have") if @restaurant.present?
  end

  private

  def set_restaurant
    @restaurant = current_restaurant_user.restaurant
  end
end
