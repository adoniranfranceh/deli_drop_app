require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order) { create(:order) }

  context '.validations' do
    it 'is invalid without a product_name' do
      item = OrderItem.new(order: order, product_name: nil, unit_price: 1000, quantity: 1, total_price: 1000)
      expect(item).not_to be_valid
      expect(item.errors.full_messages).to include("Nome do Produto não pode ficar em branco")
    end

    it 'is invalid without a unit_price' do
      item = OrderItem.new(order: order, product_name: "Pizza", unit_price: nil, quantity: 1, total_price: 1000)
      expect(item).not_to be_valid
      expect(item.errors.full_messages).to include("Preço Unitário não pode ficar em branco")
    end

    it 'is invalid without a quantity' do
      item = OrderItem.new(order: order, product_name: "Pizza", unit_price: 1000, quantity: nil, total_price: 1000)
      expect(item).not_to be_valid
      expect(item.errors.full_messages).to include("Quantidade não pode ficar em branco")
    end

    it 'is invalid with zero quantity' do
      item = OrderItem.new(order: order, product_name: "Pizza", unit_price: 1000, quantity: 0, total_price: 1000)
      expect(item).not_to be_valid
      expect(item.errors.full_messages).to include("Quantidade deve ser maior que 0")
    end

    it 'is invalid without a total_price' do
      item = OrderItem.new(order: order, product_name: "Pizza", unit_price: 1000, quantity: 1, total_price: nil)
      expect(item).not_to be_valid
      expect(item.errors.full_messages).to include("Preço Total não pode ficar em branco")
    end

    it 'is valid with all required attributes' do
      item = OrderItem.new(order: order, product_name: "Pizza", unit_price: 1000, quantity: 2, total_price: 2000)
      expect(item).to be_valid
    end

    it 'allows optional product reference' do
      item = OrderItem.new(order: order, product: nil, product_name: "Pizza", unit_price: 1000, quantity: 1, total_price: 1000)
      expect(item).to be_valid
    end
  end
end
