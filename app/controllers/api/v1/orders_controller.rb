class Api::V1::OrdersController < ActionController::API
  include OrderJson

  def index
    customer = Customer.find_by(phone: params[:phone])
    orders = customer ? customer.orders.includes(:restaurant, :order_items).order(created_at: :desc) : []

    render json: { orders: orders.map { |order| order_history_json(order) } }, status: :ok
  end

  def create
    restaurant = Restaurant.find_by(id: order_params[:restaurant_id])
    unless restaurant
      return render json: { errors: "Restaurante não encontrado" }, status: :not_found
    end

    service = OrderCreationService.new(order_params, restaurant)

    if service.call
      render json: {
        message: I18n.t("api.v1.orders.create.success"),
        order: {
          code: service.order.code,
          status: service.order.status,
          total: service.order.total,
          estimated_delivery_time: service.order.estimated_delivery_time,
          expires_at: service.order.expires_at
        }
      }, status: :created
    else
      render json: { errors: service.errors.join(", ") }, status: :unprocessable_entity
    end
  end

  def show
    order = Order.includes(order_items: :order_item_modifiers).find_by!(code: params[:code])
    render json: { order: order_tracking_json(order) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Pedido não encontrado" }, status: :not_found
  end

  def cancel
    order = Order.find_by!(code: params[:code])

    unless order.customer_can_cancel?
      return render json: { errors: "O pedido não pode mais ser cancelado" }, status: :unprocessable_entity
    end

    order.cancellation_reason = params[:reason]
    order.transition_to!(:cancelled, changed_by: "customer", note: params[:reason])

    render json: {
      message: I18n.t("api.v1.orders.cancel.success"),
      order: { code: order.code, status: order.status }
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Pedido não encontrado" }, status: :not_found
  rescue Order::InvalidTransitionError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private

  def order_params
    params.require(:order).permit(
      :restaurant_id,
      :delivery_address,
      :delivery_complement,
      :delivery_neighborhood,
      :delivery_reference,
      :payment_method,
      :change_for,
      :customer_note,
      :delivery_fee,
      :discount,
      customer: %i[name phone email],
      items: [
        :product_id,
        :quantity,
        :comment,
        { modifiers: %i[modifier_id quantity] }
      ]
    )
  end
end
