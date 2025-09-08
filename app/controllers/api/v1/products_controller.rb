class Api::V1::ProductsController < Api::V1::ApplicationController
  def create
    product = Product.new(product_params)

    if product.save
      render json: { message: I18n.t("api.v1.products.create.success"), product: product }, status: :created
    else
      render json: { status: :unprocessable_entity, errors: product.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :category_id,
      :base_price,
      :duration,
      :description,
      :image,
      :status,
      :featured,
      ingredients: [],
      modifier_groups_attributes: [ :id, :name, :input_type, :min, :max, :free_limit,
                        { modifiers_attributes: [ :id, :name, :base_price, :image ] } ]
    ).merge(restaurant: current_restaurant_user&.restaurant)
  end
end
