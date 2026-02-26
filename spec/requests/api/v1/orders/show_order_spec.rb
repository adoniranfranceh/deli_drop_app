require 'rails_helper'

RSpec.describe "GET /api/v1/orders/:code", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:customer) { create(:customer) }
  let!(:order) do
    create(:order, restaurant: restaurant, customer: customer).tap do |o|
      create(:order_item, order: o, product_name: "Pizza", unit_price: 3000, quantity: 1, total_price: 3000)
    end
  end

  context "when order exists" do
    it "returns order tracking data" do
      get api_v1_order_path(code: order.code)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      order_data = json["order"]

      expect(order_data["code"]).to eq(order.code)
      expect(order_data["status"]).to eq("pending")
      expect(order_data["restaurant_name"]).to eq(restaurant.name)
      expect(order_data["total"]).to eq(order.total)
      expect(order_data["items"].size).to eq(1)
      expect(order_data["items"].first["product_name"]).to eq("Pizza")
    end
  end

  context "when order does not exist" do
    it "returns not found" do
      get api_v1_order_path(code: "DD-XXXX")

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq("Pedido não encontrado")
    end
  end
end
