require 'rails_helper'

RSpec.describe "GET /api/v1/restaurant/orders/:id", type: :request do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:customer) { create(:customer) }

  before { login_as user }

  context "when order belongs to restaurant" do
    it "returns full order detail with items and status logs" do
      order = create(:order, restaurant: restaurant, customer: customer)
      item = create(:order_item, order: order, product_name: "X-Burguer", unit_price: 2500, quantity: 1, total_price: 2500)
      create(:order_item_modifier, order_item: item, group_name: "Extras", modifier_name: "Bacon", unit_price: 300, quantity: 1)

      order.transition_to!(:confirmed, changed_by: "restaurant")

      get api_v1_restaurant_order_path(order)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      order_data = json["order"]

      expect(order_data["code"]).to eq(order.code)
      expect(order_data["customer"]["name"]).to eq(customer.name)
      expect(order_data["customer"]["phone"]).to eq(customer.phone)
      expect(order_data["items"].size).to eq(1)
      expect(order_data["items"].first["product_name"]).to eq("X-Burguer")
      expect(order_data["items"].first["modifiers"].size).to eq(1)
      expect(order_data["items"].first["modifiers"].first["modifier_name"]).to eq("Bacon")

      expect(json["status_logs"].size).to eq(1)
      expect(json["status_logs"].first["changed_by"]).to eq("restaurant")
    end
  end

  context "when order belongs to another restaurant" do
    it "returns not found" do
      restaurant # force creation of logged-in user's restaurant
      other_restaurant = create(:restaurant)
      order = create(:order, restaurant: other_restaurant, customer: customer)

      get api_v1_restaurant_order_path(order)

      expect(response).to have_http_status(:not_found)
    end
  end
end
