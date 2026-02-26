class Api::V1::Restaurant::OrdersController < Api::V1::ApplicationController
  include OrderJson

  before_action :require_restaurant!
  before_action :set_order, only: %i[show accept reject status]

  def index
    orders = current_restaurant.orders
                               .includes(:customer, :order_items)
                               .order(created_at: :desc)

    orders = orders.where(status: Order.statuses[params[:status]]) if params[:status].present? && Order.statuses.key?(params[:status])
    orders = orders.where("orders.created_at >= ? AND orders.created_at < ?", Date.parse(params[:date]).beginning_of_day, Date.parse(params[:date]).end_of_day) if params[:date].present?

    paginated = orders.page(params[:page]).per(params[:per_page] || 15)

    render json: {
      orders: paginated.map { |order| order_summary_json(order) },
      meta: pagination_meta(paginated)
    }, status: :ok
  end

  def show
    render json: {
      order: order_json(@order),
      status_logs: @order.order_status_logs.order(:created_at).map { |log| status_log_json(log) }
    }, status: :ok
  end

  def accept
    @order.estimated_delivery_time = params[:estimated_delivery_time]
    @order.transition_to!(:confirmed, changed_by: "restaurant")

    render json: {
      message: I18n.t("api.v1.orders.accept.success"),
      order: order_summary_json(@order)
    }, status: :ok
  rescue Order::InvalidTransitionError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def reject
    @order.rejection_reason = params[:reason]
    @order.transition_to!(:rejected, changed_by: "restaurant", note: params[:reason])

    render json: {
      message: I18n.t("api.v1.orders.reject.success"),
      order: order_summary_json(@order)
    }, status: :ok
  rescue Order::InvalidTransitionError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def status
    new_status = params[:status]
    unless new_status.present? && Order.statuses.key?(new_status)
      return render json: { errors: "Status inválido" }, status: :unprocessable_entity
    end

    @order.transition_to!(new_status, changed_by: "restaurant")

    render json: {
      message: I18n.t("api.v1.orders.status.success"),
      order: order_summary_json(@order)
    }, status: :ok
  rescue Order::InvalidTransitionError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private

  def current_restaurant
    current_restaurant_user&.restaurant
  end

  def require_restaurant!
    unless current_restaurant_user&.restaurant
      render json: { errors: "Autenticação necessária" }, status: :unauthorized
    end
  end

  def set_order
    @order = current_restaurant.orders
                               .includes(order_items: :order_item_modifiers, customer: [])
                               .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Pedido não encontrado" }, status: :not_found
  end

  def pagination_meta(scope)
    {
      current_page: scope.current_page,
      total_pages: scope.total_pages,
      total_count: scope.total_count
    }
  end

  def status_log_json(log)
    {
      from_status: log.from_status,
      to_status: log.to_status,
      changed_by: log.changed_by,
      note: log.note,
      created_at: log.created_at
    }
  end
end
