require 'rails_helper'

RSpec.describe Order, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:customer) { create(:customer) }

  let(:valid_attributes) do
    {
      restaurant: restaurant,
      customer: customer,
      delivery_address: "Rua das Flores, 123",
      subtotal: 5000,
      delivery_fee: 500,
      discount: 0,
      total: 5500,
      payment_method: :pix
    }
  end

  context '.validations' do
    it 'is invalid without a delivery_address' do
      order = Order.new(valid_attributes.merge(delivery_address: nil))
      expect(order).not_to be_valid
      expect(order.errors.full_messages).to include("Endereço de Entrega não pode ficar em branco")
    end

    it 'is invalid without a subtotal' do
      order = Order.new(valid_attributes.merge(subtotal: nil))
      expect(order).not_to be_valid
      expect(order.errors.full_messages).to include("Subtotal não pode ficar em branco")
    end

    it 'is invalid without a total' do
      order = Order.new(valid_attributes.merge(total: nil))
      expect(order).not_to be_valid
      expect(order.errors.full_messages).to include("Total não pode ficar em branco")
    end

    it 'is invalid with negative subtotal' do
      order = Order.new(valid_attributes.merge(subtotal: -1))
      expect(order).not_to be_valid
      expect(order.errors.full_messages).to include("Subtotal deve ser maior ou igual a 0")
    end

    it 'is invalid without a payment_method' do
      order = Order.new(valid_attributes.merge(payment_method: nil))
      expect(order).not_to be_valid
    end

    it 'is valid with all required attributes' do
      order = Order.new(valid_attributes)
      expect(order).to be_valid
    end
  end

  context '.code generation' do
    it 'generates a code automatically on create' do
      order = create(:order, restaurant: restaurant, customer: customer)
      expect(order.code).to match(/\ADD-[A-Z0-9]{4}\z/)
    end

    it 'generates unique codes' do
      codes = 10.times.map { create(:order, restaurant: restaurant, customer: customer).code }
      expect(codes.uniq.size).to eq(10)
    end
  end

  context '.expires_at' do
    it 'sets expires_at on create' do
      order = create(:order, restaurant: restaurant, customer: customer)
      expect(order.expires_at).to be_within(1.second).of(Time.current + 10.minutes)
    end
  end

  context '.status transitions' do
    let(:order) { create(:order, restaurant: restaurant, customer: customer) }

    it 'transitions from pending to confirmed' do
      order.transition_to!(:confirmed, changed_by: "restaurant")
      expect(order.reload).to be_confirmed
      expect(order.confirmed_at).to be_present
    end

    it 'transitions from pending to rejected' do
      order.transition_to!(:rejected, changed_by: "restaurant", note: "Sem estoque")
      expect(order.reload).to be_rejected
      expect(order.cancelled_at).to be_present
    end

    it 'transitions from pending to cancelled by customer' do
      order.transition_to!(:cancelled, changed_by: "customer")
      expect(order.reload).to be_cancelled
      expect(order.cancelled_at).to be_present
    end

    it 'rejects invalid transition from pending to preparing' do
      expect {
        order.transition_to!(:preparing, changed_by: "restaurant")
      }.to raise_error(Order::InvalidTransitionError)
    end

    it 'transitions through full delivery flow' do
      order.transition_to!(:confirmed, changed_by: "restaurant")
      order.transition_to!(:preparing, changed_by: "restaurant")
      order.transition_to!(:ready, changed_by: "restaurant")
      order.transition_to!(:out_for_delivery, changed_by: "restaurant")
      order.transition_to!(:delivered, changed_by: "restaurant")

      order.reload
      expect(order).to be_delivered
      expect(order.confirmed_at).to be_present
      expect(order.preparing_at).to be_present
      expect(order.ready_at).to be_present
      expect(order.out_for_delivery_at).to be_present
      expect(order.delivered_at).to be_present
    end

    it 'creates status log on transition' do
      expect {
        order.transition_to!(:confirmed, changed_by: "restaurant")
      }.to change(OrderStatusLog, :count).by(1)

      log = order.order_status_logs.last
      expect(log.from_status).to eq(Order.statuses[:pending])
      expect(log.to_status).to eq(Order.statuses[:confirmed])
      expect(log.changed_by).to eq("restaurant")
    end
  end

  context '.customer_can_cancel?' do
    it 'allows cancellation when pending' do
      order = create(:order, restaurant: restaurant, customer: customer)
      expect(order.customer_can_cancel?).to be true
    end

    it 'allows cancellation when confirmed' do
      order = create(:order, :confirmed, restaurant: restaurant, customer: customer)
      expect(order.customer_can_cancel?).to be true
    end

    it 'disallows cancellation when preparing' do
      order = create(:order, :preparing, restaurant: restaurant, customer: customer)
      expect(order.customer_can_cancel?).to be false
    end
  end

  context '.restaurant opening hours validation' do
    it 'is valid when restaurant has no opening hours set' do
      order = Order.new(valid_attributes)
      expect(order).to be_valid
    end

    it 'is invalid when restaurant is closed' do
      restaurant.update!(
        opening_time: Time.parse("08:00"),
        closing_time: Time.parse("09:00"),
        open_days: [ Time.current.wday ]
      )

      travel_to Time.current.change(hour: 22, min: 0) do
        order = Order.new(valid_attributes)
        expect(order).not_to be_valid
        expect(order.errors.full_messages).to include("O restaurante está fechado no momento")
      end
    end

    it 'is valid when restaurant is open' do
      restaurant.update!(
        opening_time: Time.parse("08:00"),
        closing_time: Time.parse("23:00"),
        open_days: [ Time.current.wday ]
      )

      travel_to Time.current.change(hour: 12, min: 0) do
        order = Order.new(valid_attributes)
        expect(order).to be_valid
      end
    end
  end
end
