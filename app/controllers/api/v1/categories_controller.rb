class Api::V1::CategoriesController < Api::V1::ApplicationController
  def index
    categories = current_restaurant_user.restaurant.categories
    render json: categories.select(:id, :name)
  end

  def create
    category = Category.new(category_params)

    if category.save
      render json: { message: I18n.t("api.v1.categories.create.success"), category: category }, status: :created
    else
      render json: { status: :unprocessable_entity, errors: category.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description).merge(restaurant: current_restaurant_user&.restaurant)
  end
end
