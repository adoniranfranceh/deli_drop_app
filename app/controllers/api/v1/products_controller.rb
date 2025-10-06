class Api::V1::ProductsController < Api::V1::ApplicationController
  def create
    product = Product.new(product_params)

    if product.save
      render json: { message: I18n.t("api.v1.products.create.success"), product: product }, status: :created
    else
      render json: { status: :unprocessable_entity, errors: product.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find params[:id]
    authorize product

    if product.update(product_params)
      render json: { message: I18n.t("api.v1.products.update.success"), product: product }, status: :ok
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
      modifier_groups_attributes: [ :id, :name, :input_type, :min, :max, :free_limit, :_destroy,
                        { modifiers_attributes: [ :id, :name, :base_price, :image, :_destroy ] } ]
    ).merge(restaurant: current_restaurant_user&.restaurant)
  end
end
