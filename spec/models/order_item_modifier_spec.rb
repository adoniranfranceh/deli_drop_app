require 'rails_helper'

RSpec.describe OrderItemModifier, type: :model do
  let(:order) { create(:order) }
  let(:order_item) { create(:order_item, order: order) }

  context '.validations' do
    it 'is invalid without a group_name' do
      mod = OrderItemModifier.new(order_item: order_item, group_name: nil, modifier_name: "Grande", unit_price: 500, quantity: 1)
      expect(mod).not_to be_valid
      expect(mod.errors.full_messages).to include("Nome do Grupo não pode ficar em branco")
    end

    it 'is invalid without a modifier_name' do
      mod = OrderItemModifier.new(order_item: order_item, group_name: "Tamanho", modifier_name: nil, unit_price: 500, quantity: 1)
      expect(mod).not_to be_valid
      expect(mod.errors.full_messages).to include("Nome do Modificador não pode ficar em branco")
    end

    it 'is invalid without a unit_price' do
      mod = OrderItemModifier.new(order_item: order_item, group_name: "Tamanho", modifier_name: "Grande", unit_price: nil, quantity: 1)
      expect(mod).not_to be_valid
      expect(mod.errors.full_messages).to include("Preço Unitário não pode ficar em branco")
    end

    it 'is invalid with zero quantity' do
      mod = OrderItemModifier.new(order_item: order_item, group_name: "Tamanho", modifier_name: "Grande", unit_price: 500, quantity: 0)
      expect(mod).not_to be_valid
      expect(mod.errors.full_messages).to include("Quantidade deve ser maior que 0")
    end

    it 'is valid with all required attributes' do
      mod = OrderItemModifier.new(order_item: order_item, group_name: "Tamanho", modifier_name: "Grande", unit_price: 500, quantity: 1)
      expect(mod).to be_valid
    end

    it 'allows optional modifier reference' do
      mod = OrderItemModifier.new(order_item: order_item, modifier: nil, group_name: "Tamanho", modifier_name: "Grande", unit_price: 500, quantity: 1)
      expect(mod).to be_valid
    end
  end
end
