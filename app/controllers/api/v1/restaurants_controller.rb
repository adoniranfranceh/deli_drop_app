class Api::V1::RestaurantsController < Api::V1::ApplicationController
  def create
    restaurant = current_restaurant_user.build_restaurant(restaurant_params)

    if restaurant.save
      render json: { message: I18n.t("api.v1.restaurants.create.success"), restaurant: restaurant }, status: :created
    else
      render json: { status: :unprocessable_entity, message: restaurant.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :culinary_style, :description, :image, :phone, :address)
  end
end
