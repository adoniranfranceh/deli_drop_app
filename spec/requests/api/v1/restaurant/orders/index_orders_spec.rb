require 'rails_helper'

RSpec.describe "GET /api/v1/restaurant/orders", type: :request do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:customer) { create(:customer) }

  context "when authenticated" do
    before { login_as user }

    it "lists restaurant orders ordered by created_at desc" do
      old_order = create(:order, restaurant: restaurant, customer: customer, created_at: 2.hours.ago)
      new_order = create(:order, restaurant: restaurant, customer: customer, created_at: 1.hour.ago)

      get api_v1_restaurant_orders_path

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["orders"].size).to eq(2)
      expect(json["orders"].first["id"]).to eq(new_order.id)
      expect(json["orders"].second["id"]).to eq(old_order.id)
    end

    it "filters by status" do
      pending_order = create(:order, restaurant: restaurant, customer: customer)
      confirmed_order = create(:order, :confirmed, restaurant: restaurant, customer: customer)

      get api_v1_restaurant_orders_path, params: { status: "confirmed" }

      json = JSON.parse(response.body)
      expect(json["orders"].size).to eq(1)
      expect(json["orders"].first["id"]).to eq(confirmed_order.id)
    end

    it "filters by date" do
      today_order = create(:order, restaurant: restaurant, customer: customer, created_at: Time.current)
      yesterday_order = create(:order, restaurant: restaurant, customer: customer, created_at: 1.day.ago)

      get api_v1_restaurant_orders_path, params: { date: Date.current.to_s }

      json = JSON.parse(response.body)
      order_ids = json["orders"].map { |o| o["id"] }
      expect(order_ids).to include(today_order.id)
      expect(order_ids).not_to include(yesterday_order.id)
    end

    it "does not list orders from other restaurants" do
      other_restaurant = create(:restaurant)
      other_order = create(:order, restaurant: other_restaurant, customer: customer)
      my_order = create(:order, restaurant: restaurant, customer: customer)

      get api_v1_restaurant_orders_path

      json = JSON.parse(response.body)
      order_ids = json["orders"].map { |o| o["id"] }
      expect(order_ids).to include(my_order.id)
      expect(order_ids).not_to include(other_order.id)
    end

    it "paginates results" do
      create_list(:order, 20, restaurant: restaurant, customer: customer)

      get api_v1_restaurant_orders_path, params: { page: 1, per_page: 5 }

      json = JSON.parse(response.body)
      expect(json["orders"].size).to eq(5)
      expect(json["meta"]["current_page"]).to eq(1)
      expect(json["meta"]["total_pages"]).to eq(4)
      expect(json["meta"]["total_count"]).to eq(20)
    end

    it "returns summary fields" do
      order = create(:order, restaurant: restaurant, customer: customer)

      get api_v1_restaurant_orders_path

      json = JSON.parse(response.body)
      order_data = json["orders"].first

      expect(order_data).to have_key("id")
      expect(order_data).to have_key("code")
      expect(order_data).to have_key("status")
      expect(order_data).to have_key("customer_name")
      expect(order_data).to have_key("customer_phone")
      expect(order_data).to have_key("total")
      expect(order_data).to have_key("payment_method")
      expect(order_data).to have_key("created_at")
    end
  end

  context "when not authenticated" do
    it "returns unauthorized" do
      get api_v1_restaurant_orders_path

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
