require 'rails_helper'

RSpec.describe OrderCreationService do
  let(:restaurant) { create(:restaurant) }
  let(:category) { restaurant.categories.first }
  let!(:product) { create(:product, restaurant: restaurant, category: category, base_price: 1000, name: "Hambúrguer") }
  let!(:modifier_group) { create(:modifier_group, product: product, name: "Adicionais") }
  let!(:modifier) { create(:modifier, modifier_group: modifier_group, name: "Bacon", base_price: 300) }

  let(:valid_params) do
    ActionController::Parameters.new({
      restaurant_id: restaurant.id,
      delivery_address: "Rua A, 100",
      delivery_neighborhood: "Centro",
      payment_method: "pix",
      delivery_fee: 500,
      discount: 0,
      customer: { name: "Maria", phone: "89 99999-5555" },
      items: [
        {
          product_id: product.id,
          quantity: 1,
          comment: "Bem passado",
          modifiers: [
            { modifier_id: modifier.id, quantity: 2 }
          ]
        }
      ]
    }).permit!
  end

  describe "#call" do
    it "creates order, customer, items and modifiers" do
      service = OrderCreationService.new(valid_params, restaurant)

      expect(service.call).to be true
      expect(service.order).to be_persisted

      order = service.order
      expect(order.order_items.count).to eq(1)
      expect(order.order_items.first.order_item_modifiers.count).to eq(1)
      expect(order.customer.phone).to eq("89 99999-5555")
    end

    it "calculates item total correctly with modifiers" do
      service = OrderCreationService.new(valid_params, restaurant)
      service.call

      item = service.order.order_items.first
      # base_price(1000) + modifier(300 * 2) = 1600 * qty(1) = 1600
      expect(item.total_price).to eq(1600)
    end

    it "calculates order subtotal and total" do
      service = OrderCreationService.new(valid_params, restaurant)
      service.call

      order = service.order
      expect(order.subtotal).to eq(1600)
      # subtotal(1600) + delivery_fee(500) - discount(0) = 2100
      expect(order.total).to eq(2100)
    end

    it "snapshots product and modifier data" do
      service = OrderCreationService.new(valid_params, restaurant)
      service.call

      item = service.order.order_items.first
      expect(item.product_name).to eq("Hambúrguer")
      expect(item.unit_price).to eq(1000)

      mod = item.order_item_modifiers.first
      expect(mod.group_name).to eq("Adicionais")
      expect(mod.modifier_name).to eq("Bacon")
      expect(mod.unit_price).to eq(300)
    end

    it "finds existing customer by phone" do
      existing = create(:customer, name: "Maria Antiga", phone: "89 99999-5555")

      service = OrderCreationService.new(valid_params, restaurant)
      service.call

      expect(service.order.customer).to eq(existing)
      expect(existing.reload.name).to eq("Maria")
    end

    context "with invalid data" do
      it "returns false when product not found" do
        params = valid_params.deep_dup
        params[:items][0][:product_id] = 99999

        service = OrderCreationService.new(params, restaurant)
        expect(service.call).to be false
        expect(service.errors).to include(match(/não encontrado/))
      end

      it "returns false when modifier not found" do
        params = valid_params.deep_dup
        params[:items][0][:modifiers][0][:modifier_id] = 99999

        service = OrderCreationService.new(params, restaurant)
        expect(service.call).to be false
        expect(service.errors).to include(match(/não encontrado/))
      end

      it "returns false when no items" do
        params = valid_params.deep_dup
        params[:items] = []

        service = OrderCreationService.new(params, restaurant)
        expect(service.call).to be false
        expect(service.errors).to include("Nenhum item informado no pedido")
      end

      it "returns false when customer phone is blank" do
        params = valid_params.deep_dup
        params[:customer][:phone] = ""

        service = OrderCreationService.new(params, restaurant)
        expect(service.call).to be false
        expect(service.errors).not_to be_empty
      end
    end

    context "with multiple items" do
      let!(:product2) { create(:product, restaurant: restaurant, category: category, base_price: 2000, name: "Pizza") }

      it "calculates subtotal for multiple items" do
        params = valid_params.deep_dup
        params[:items] << { product_id: product2.id, quantity: 3 }

        service = OrderCreationService.new(params, restaurant)
        service.call

        order = service.order
        expect(order.order_items.count).to eq(2)
        # item1: (1000 + 300*2) * 1 = 1600
        # item2: 2000 * 3 = 6000
        # subtotal = 7600
        expect(order.subtotal).to eq(7600)
        # total = 7600 + 500 = 8100
        expect(order.total).to eq(8100)
      end
    end
  end
end
