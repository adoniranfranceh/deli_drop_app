class RestaurantQuery
  def initialize(params)
    @params = params
  end

  def call
    scope = Restaurant.includes(:products, :categories).distinct.order(:id)

    scope = filter_by_query(scope)
    scope = filter_by_category(scope)
    scope = paginate(scope)

    scope
  end

  private

  def filter_by_query(scope)
    return scope unless @params[:query].present?

    query = "%#{@params[:query]}%"
    scope.left_joins(:products)
        .where(
          "restaurants.name ILIKE :query OR
          restaurants.description ILIKE :query OR
          products.name ILIKE :query OR
          products.description ILIKE :query OR
          array_to_string(products.ingredients, ',') ILIKE :query",
          query:
        )
        .distinct
  end

  def filter_by_category(scope)
    return scope unless @params[:category].present?

    category_name = "%#{@params[:category]}%"
    scope.joins(products: :category)
         .where("categories.name ILIKE :category", category: category_name)
         .distinct
  end

  def paginate(scope)
    scope.page(@params[:page]).per(@params[:per_page] || 10)
  end
end
