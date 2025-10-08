class Api::V1::ProductsController < Api::V1::ApplicationController
  include ProductsJson

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

  def index
    products = ProductQuery.new(params).call

    render json: {
      products: products_json(full: params[:full] == "true",
        collection: products
      ),
      meta: pagination_meta(products)
    }, status: :ok
  end

  private

  def pagination_meta(scope)
    {
      current_page: scope.current_page,
      total_pages: scope.total_pages,
      total_count: scope.total_count
    }
  end

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
