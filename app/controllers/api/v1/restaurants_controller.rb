class Api::V1::RestaurantsController < Api::V1::ApplicationController
  def create
    restaurant = Restaurant.new(restaurant_params)

    if restaurant.save
      render json: { message: I18n.t("api.v1.restaurants.create.success"), restaurant: restaurant }, status: :created
    else
      render json: { status: :unprocessable_entity, errors: restaurant.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    restaurant = current_restaurant_user.restaurant

    if restaurant.update(restaurant_params)
      render json: { message: I18n.t("api.v1.restaurants.update.success"), restaurant: restaurant }, status: :ok
    else
      render json: { status: :unprocessable_entity, errors: restaurant.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(
      :name,
      :culinary_style,
      :description,
      :image,
      :phone,
      :address
    ).merge(restaurant_user: current_restaurant_user)
  end
end
