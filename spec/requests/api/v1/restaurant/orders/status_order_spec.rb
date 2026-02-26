require 'rails_helper'

RSpec.describe "PATCH /api/v1/restaurant/orders/:id/status", type: :request do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:customer) { create(:customer) }

  before { login_as user }

  context "full delivery flow" do
    it "advances through all statuses" do
      order = create(:order, restaurant: restaurant, customer: customer)

      # pending → confirmed (via accept)
      patch accept_api_v1_restaurant_order_path(order), params: { estimated_delivery_time: 30 }
      expect(response).to have_http_status(:ok)

      # confirmed → preparing
      patch status_api_v1_restaurant_order_path(order), params: { status: "preparing" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["order"]["status"]).to eq("preparing")

      # preparing → ready
      patch status_api_v1_restaurant_order_path(order), params: { status: "ready" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["order"]["status"]).to eq("ready")

      # ready → out_for_delivery
      patch status_api_v1_restaurant_order_path(order), params: { status: "out_for_delivery" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["order"]["status"]).to eq("out_for_delivery")

      # out_for_delivery → delivered
      patch status_api_v1_restaurant_order_path(order), params: { status: "delivered" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["order"]["status"]).to eq("delivered")

      order.reload
      expect(order).to be_delivered
      expect(order.order_status_logs.count).to eq(5)
    end
  end

  context "invalid transitions" do
    it "returns error when skipping status" do
      order = create(:order, restaurant: restaurant, customer: customer)

      patch status_api_v1_restaurant_order_path(order), params: { status: "preparing" }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Transição de status inválida")
    end

    it "returns error with invalid status value" do
      order = create(:order, restaurant: restaurant, customer: customer)

      patch status_api_v1_restaurant_order_path(order), params: { status: "fake_status" }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Status inválido")
    end
  end

  context "restaurant cancellation during preparing" do
    it "allows restaurant to cancel" do
      order = create(:order, :preparing, restaurant: restaurant, customer: customer)

      patch status_api_v1_restaurant_order_path(order), params: { status: "cancelled" }

      expect(response).to have_http_status(:ok)
      expect(order.reload).to be_cancelled
    end
  end
end
