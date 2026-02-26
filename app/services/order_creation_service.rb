class OrderCreationService
  attr_reader :order, :errors

  def initialize(params, restaurant)
    @params = params
    @restaurant = restaurant
    @errors = []
  end

  def call
    ActiveRecord::Base.transaction do
      find_or_create_customer!
      build_order!
      build_order_items!
      calculate_totals!
      @order.save!
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    @errors = e.record.errors.full_messages
    false
  rescue ItemNotFoundError => e
    @errors = [e.message]
    false
  end

  private

  def find_or_create_customer!
    customer_data = @params[:customer]

    if customer_data.blank? || customer_data[:phone].blank?
      customer = Customer.new(phone: customer_data&.dig(:phone), name: customer_data&.dig(:name))
      customer.validate
      raise ActiveRecord::RecordInvalid.new(customer)
    end

    @customer = Customer.find_or_initialize_by(phone: customer_data[:phone])
    @customer.name = customer_data[:name] if customer_data[:name].present?
    @customer.email = customer_data[:email] if customer_data[:email].present?
    @customer.save!
  end

  def build_order!
    @order = Order.new(
      restaurant: @restaurant,
      customer: @customer,
      delivery_address: @params[:delivery_address],
      delivery_complement: @params[:delivery_complement],
      delivery_neighborhood: @params[:delivery_neighborhood],
      delivery_reference: @params[:delivery_reference],
      payment_method: @params[:payment_method],
      change_for: @params[:change_for],
      customer_note: @params[:customer_note],
      delivery_fee: @params[:delivery_fee].to_i,
      discount: @params[:discount].to_i,
      subtotal: 0,
      total: 0
    )
  end

  def build_order_items!
    items_data = @params[:items]
    raise ItemNotFoundError, "Nenhum item informado no pedido" if items_data.blank?

    items_data.each do |item_data|
      product = @restaurant.products.active.find_by(id: item_data[:product_id])
      raise ItemNotFoundError, "Produto '#{item_data[:product_id]}' não encontrado ou indisponível" unless product

      quantity = item_data[:quantity].to_i
      quantity = 1 if quantity < 1

      modifiers_total = 0
      order_item = @order.order_items.build(
        product: product,
        product_name: product.name,
        product_image: product.image,
        unit_price: product.base_price,
        quantity: quantity,
        comment: item_data[:comment],
        total_price: 0
      )

      if item_data[:modifiers].present?
        item_data[:modifiers].each do |mod_data|
          modifier = Modifier.joins(:modifier_group)
                             .where(modifier_groups: { product_id: product.id })
                             .find_by(id: mod_data[:modifier_id])
          raise ItemNotFoundError, "Modificador '#{mod_data[:modifier_id]}' não encontrado para o produto '#{product.name}'" unless modifier

          mod_quantity = mod_data[:quantity].to_i
          mod_quantity = 1 if mod_quantity < 1

          order_item.order_item_modifiers.build(
            modifier: modifier,
            group_name: modifier.modifier_group.name,
            modifier_name: modifier.name,
            unit_price: modifier.base_price.to_i,
            quantity: mod_quantity
          )

          modifiers_total += modifier.base_price.to_i * mod_quantity
        end
      end

      order_item.total_price = (product.base_price + modifiers_total) * quantity
    end
  end

  def calculate_totals!
    @order.subtotal = @order.order_items.sum(&:total_price)
    @order.total = @order.subtotal + @order.delivery_fee - @order.discount
  end

  class ItemNotFoundError < StandardError; end
end
