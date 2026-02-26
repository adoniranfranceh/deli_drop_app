require 'rails_helper'

RSpec.describe "PATCH /api/v1/restaurant/orders/:id/accept", type: :request do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:customer) { create(:customer) }

  before { login_as user }

  context "when order is pending" do
    it "accepts and sets estimated delivery time" do
      order = create(:order, restaurant: restaurant, customer: customer)

      patch accept_api_v1_restaurant_order_path(order), params: { estimated_delivery_time: 40 }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Pedido aceito com sucesso")
      expect(json["order"]["status"]).to eq("confirmed")
      expect(json["order"]["estimated_delivery_time"]).to eq(40)

      order.reload
      expect(order).to be_confirmed
      expect(order.confirmed_at).to be_present
      expect(order.estimated_delivery_time).to eq(40)
    end

    it "creates a status log" do
      order = create(:order, restaurant: restaurant, customer: customer)

      expect {
        patch accept_api_v1_restaurant_order_path(order), params: { estimated_delivery_time: 30 }
      }.to change(OrderStatusLog, :count).by(1)
    end
  end

  context "when order is already confirmed" do
    it "returns error" do
      order = create(:order, :confirmed, restaurant: restaurant, customer: customer)

      patch accept_api_v1_restaurant_order_path(order), params: { estimated_delivery_time: 30 }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Transição de status inválida")
    end
  end

  context "when not authenticated" do
    it "returns unauthorized" do
      order = create(:order, restaurant: restaurant, customer: customer)

      Warden.test_reset!

      patch accept_api_v1_restaurant_order_path(order), params: { estimated_delivery_time: 30 }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
