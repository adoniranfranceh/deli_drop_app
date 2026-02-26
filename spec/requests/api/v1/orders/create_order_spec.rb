require 'rails_helper'

RSpec.describe "POST /api/v1/orders", type: :request do
  let(:restaurant) { create(:restaurant) }
  let(:category) { restaurant.categories.first }
  let!(:product) { create(:product, restaurant: restaurant, category: category, base_price: 2500, name: "X-Burguer") }
  let!(:modifier_group) { create(:modifier_group, product: product, name: "Extras") }
  let!(:modifier) { create(:modifier, modifier_group: modifier_group, name: "Queijo extra", base_price: 500) }

  let(:valid_params) do
    {
      order: {
        restaurant_id: restaurant.id,
        delivery_address: "Rua das Flores, 123",
        delivery_complement: "Apto 4B",
        delivery_neighborhood: "Centro",
        delivery_reference: "Próximo à padaria",
        payment_method: "pix",
        customer_note: "Portão azul",
        delivery_fee: 500,
        customer: {
          name: "João Silva",
          phone: "89 99999-0001"
        },
        items: [
          {
            product_id: product.id,
            quantity: 2,
            comment: "Sem cebola",
            modifiers: [
              { modifier_id: modifier.id, quantity: 1 }
            ]
          }
        ]
      }
    }
  end

  context "when order is valid" do
    it "creates order and returns code" do
      post api_v1_orders_path, params: valid_params

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json["order"]["code"]).to match(/\ADD-[A-Z0-9]{4}\z/)
      expect(json["order"]["status"]).to eq("pending")
      expect(json["message"]).to eq("Pedido enviado com sucesso!")
    end

    it "snapshots product data correctly" do
      post api_v1_orders_path, params: valid_params

      order = Order.last
      item = order.order_items.first

      expect(item.product_name).to eq("X-Burguer")
      expect(item.unit_price).to eq(2500)
      expect(item.quantity).to eq(2)
    end

    it "snapshots modifier data correctly" do
      post api_v1_orders_path, params: valid_params

      order = Order.last
      mod = order.order_items.first.order_item_modifiers.first

      expect(mod.group_name).to eq("Extras")
      expect(mod.modifier_name).to eq("Queijo extra")
      expect(mod.unit_price).to eq(500)
      expect(mod.quantity).to eq(1)
    end

    it "calculates totals correctly" do
      post api_v1_orders_path, params: valid_params

      order = Order.last
      # (2500 base + 500 modifier) * 2 qty = 6000
      expect(order.order_items.first.total_price).to eq(6000)
      expect(order.subtotal).to eq(6000)
      # 6000 + 500 delivery_fee = 6500
      expect(order.total).to eq(6500)
    end

    it "finds or creates customer by phone" do
      expect {
        post api_v1_orders_path, params: valid_params
      }.to change(Customer, :count).by(1)

      customer = Customer.last
      expect(customer.name).to eq("João Silva")
      expect(customer.phone).to eq("89 99999-0001")
    end

    it "reuses existing customer by phone" do
      create(:customer, name: "João", phone: "89 99999-0001")

      expect {
        post api_v1_orders_path, params: valid_params
      }.not_to change(Customer, :count)
    end

    it "sets expires_at" do
      post api_v1_orders_path, params: valid_params

      order = Order.last
      expect(order.expires_at).to be_within(2.seconds).of(Time.current + 10.minutes)
    end
  end

  context "when order is invalid" do
    it "returns error when restaurant not found" do
      params = valid_params.deep_dup
      params[:order][:restaurant_id] = 99999

      post api_v1_orders_path, params: params

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Restaurante não encontrado")
    end

    it "returns error when no items provided" do
      params = valid_params.deep_dup
      params[:order][:items] = []

      post api_v1_orders_path, params: params

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Nenhum item informado no pedido")
    end

    it "returns error when product not found" do
      params = valid_params.deep_dup
      params[:order][:items][0][:product_id] = 99999

      post api_v1_orders_path, params: params

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("não encontrado")
    end

    it "returns error when delivery_address is blank" do
      params = valid_params.deep_dup
      params[:order][:delivery_address] = ""

      post api_v1_orders_path, params: params

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns error when customer phone is blank" do
      params = valid_params.deep_dup
      params[:order][:customer][:phone] = ""

      post api_v1_orders_path, params: params

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "snapshot integrity" do
    it "preserves original price even if product price changes after order" do
      post api_v1_orders_path, params: valid_params

      product.update!(base_price: 9999)

      order = Order.last
      item = order.order_items.first
      expect(item.unit_price).to eq(2500)
    end
  end
end
