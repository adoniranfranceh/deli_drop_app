require 'rails_helper'

RSpec.describe "PATCH /api/v1/restaurant/orders/:id/reject", type: :request do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:customer) { create(:customer) }

  before { login_as user }

  context "when order is pending" do
    it "rejects with reason" do
      order = create(:order, restaurant: restaurant, customer: customer)

      patch reject_api_v1_restaurant_order_path(order), params: { reason: "Sem ingredientes" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["order"]["status"]).to eq("rejected")

      order.reload
      expect(order).to be_rejected
      expect(order.rejection_reason).to eq("Sem ingredientes")
      expect(order.cancelled_at).to be_present
    end
  end

  context "when order is already confirmed" do
    it "returns error" do
      order = create(:order, :confirmed, restaurant: restaurant, customer: customer)

      patch reject_api_v1_restaurant_order_path(order), params: { reason: "Fechamos" }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
