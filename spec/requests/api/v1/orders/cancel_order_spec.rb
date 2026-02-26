require 'rails_helper'

RSpec.describe "PATCH /api/v1/orders/:code/cancel", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:customer) { create(:customer) }

  context "when order is pending" do
    it "cancels successfully" do
      order = create(:order, restaurant: restaurant, customer: customer)

      patch cancel_api_v1_order_path(code: order.code), params: { reason: "Mudei de ideia" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["order"]["status"]).to eq("cancelled")

      order.reload
      expect(order).to be_cancelled
      expect(order.cancellation_reason).to eq("Mudei de ideia")
      expect(order.cancelled_at).to be_present
    end
  end

  context "when order is confirmed" do
    it "cancels successfully" do
      order = create(:order, :confirmed, restaurant: restaurant, customer: customer)

      patch cancel_api_v1_order_path(code: order.code)

      expect(response).to have_http_status(:ok)
      expect(order.reload).to be_cancelled
    end
  end

  context "when order is preparing" do
    it "returns error" do
      order = create(:order, :preparing, restaurant: restaurant, customer: customer)

      patch cancel_api_v1_order_path(code: order.code)

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("não pode mais ser cancelado")
    end
  end

  context "when order not found" do
    it "returns not found" do
      patch cancel_api_v1_order_path(code: "DD-XXXX")

      expect(response).to have_http_status(:not_found)
    end
  end
end
