module OrderJson
  extend ActiveSupport::Concern

  def order_json(order)
    {
      id: order.id,
      code: order.code,
      status: order.status,
      restaurant_id: order.restaurant_id,
      restaurant_name: order.restaurant.name,
      customer: customer_json(order.customer),
      delivery_address: order.delivery_address,
      delivery_complement: order.delivery_complement,
      delivery_neighborhood: order.delivery_neighborhood,
      delivery_reference: order.delivery_reference,
      subtotal: order.subtotal,
      delivery_fee: order.delivery_fee,
      discount: order.discount,
      total: order.total,
      payment_method: order.payment_method,
      change_for: order.change_for,
      payment_status: order.payment_status,
      customer_note: order.customer_note,
      rejection_reason: order.rejection_reason,
      cancellation_reason: order.cancellation_reason,
      estimated_delivery_time: order.estimated_delivery_time,
      expires_at: order.expires_at,
      items: order.order_items.includes(:order_item_modifiers).map { |item| order_item_json(item) },
      timestamps: order_timestamps(order),
      created_at: order.created_at
    }
  end

  def order_summary_json(order)
    {
      id: order.id,
      code: order.code,
      status: order.status,
      customer_name: order.customer.name,
      customer_phone: order.customer.phone,
      total: order.total,
      payment_method: order.payment_method,
      items_count: order.order_items.size,
      estimated_delivery_time: order.estimated_delivery_time,
      expires_at: order.expires_at,
      created_at: order.created_at
    }
  end

  def order_history_json(order)
    {
      code: order.code,
      status: order.status,
      restaurant_name: order.restaurant.name,
      total: order.total,
      items_count: order.order_items.size,
      created_at: order.created_at
    }
  end

  def order_tracking_json(order)
    {
      code: order.code,
      status: order.status,
      restaurant_name: order.restaurant.name,
      total: order.total,
      payment_method: order.payment_method,
      payment_status: order.payment_status,
      estimated_delivery_time: order.estimated_delivery_time,
      expires_at: order.expires_at,
      items: order.order_items.includes(:order_item_modifiers).map { |item| order_item_json(item) },
      timestamps: order_timestamps(order),
      created_at: order.created_at
    }
  end

  private

  def customer_json(customer)
    {
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      email: customer.email
    }
  end

  def order_item_json(item)
    {
      id: item.id,
      product_name: item.product_name,
      product_image: item.product_image,
      unit_price: item.unit_price,
      quantity: item.quantity,
      total_price: item.total_price,
      comment: item.comment,
      modifiers: item.order_item_modifiers.map { |mod| order_item_modifier_json(mod) }
    }
  end

  def order_item_modifier_json(mod)
    {
      id: mod.id,
      group_name: mod.group_name,
      modifier_name: mod.modifier_name,
      unit_price: mod.unit_price,
      quantity: mod.quantity
    }
  end

  def order_timestamps(order)
    {
      confirmed_at: order.confirmed_at,
      preparing_at: order.preparing_at,
      ready_at: order.ready_at,
      out_for_delivery_at: order.out_for_delivery_at,
      delivered_at: order.delivered_at,
      cancelled_at: order.cancelled_at
    }
  end
end
