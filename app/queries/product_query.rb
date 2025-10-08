class ProductQuery
  def initialize(params)
    @params = params
  end

  def call
    scope = Product.includes(:category, :restaurant).distinct.order(:id)

    scope = filter_by_query(scope)
    scope = filter_by_category(scope)
    scope = paginate(scope)

    scope
  end

  private

  def filter_by_query(scope)
    return scope unless @params[:query].present?

    query = "%#{@params[:query]}%"
    scope.where("products.name ILIKE :query OR
                 products.description ILIKE :query OR
                array_to_string(products.ingredients, ',') ILIKE :query",
                query:
                ).distinct
  end

  def filter_by_category(scope)
    return scope unless @params[:category].present?

    query = "%#{@params[:category]}%"
    scope.joins(:category)
         .where("LOWER(categories.name) ILIKE :query", query:)
  end

  def paginate(scope)
    scope.page(@params[:page]).per(@params[:per_page] || 10)
  end
end
