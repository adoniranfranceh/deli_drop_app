class Api::V1::RestaurantsController < Api::V1::ApplicationController
  before_action :set_restaurant, only: %i[update show]
  include RestaurantJson
  include RestaurantsJson

  def create
    restaurant = Restaurant.new(restaurant_params)

    if restaurant.save
      render json: { message: I18n.t("api.v1.restaurants.create.success"), restaurant: restaurant }, status: :created
    else
      render json: { status: :unprocessable_entity, errors: restaurant.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    authorize @restaurant

    if @restaurant.update(restaurant_params)
      render json: { message: I18n.t("api.v1.restaurants.update.success"), restaurant: @restaurant }, status: :ok
    else
      render json: { status: :unprocessable_entity, errors: @restaurant.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def show
    render json: restaurant_json(@restaurant)
  end

  def index
    restaurants = RestaurantQuery.new(params).call

    filtered = restaurants.joins(:products).distinct

    render json: {
      restaurants: restaurants_json(
        full: params[:full] == "true",
        collection: filtered
      ),
      meta: pagination_meta(filtered)
    }
  end

  private

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

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
