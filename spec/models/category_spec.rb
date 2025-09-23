require 'rails_helper'

RSpec.describe Category, type: :model do
   let(:user) { create(:restaurant_user) }
   let(:restaurant) { create(:restaurant, restaurant_user: user) }

  context '.valid' do
    it 'is invalid without a name' do
      category = Category.new(name: nil, restaurant: restaurant, description: "Pizzas diversas")
      expect(category).not_to be_valid
      expect(category.errors.full_messages).to include("Nome não pode ficar em branco")
    end

    it 'is valid without a description' do
      category = Category.new(description: nil, restaurant: restaurant, name: "Pizzas")
      expect(category).to be_valid
      expect(category.errors.full_messages).not_to include("Descrição não pode ficar em branco")
    end

    it 'enforces uniqueness of name' do
      create(:category, name: "Pizzas", restaurant: restaurant)
      category = Category.new(description: nil, restaurant: restaurant, name: "pizzas")
      expect(category).not_to be_valid
      expect(category.errors.full_messages).to include("Nome já está em uso")
    end
  end

  context '.with_products_stats' do
    let(:category) { create(:category, restaurant:) }
    let(:active_product) { create(:product, category:, status: :active, base_price: 100, restaurant:) }
    let(:inactive_product) { create(:product, category:, status: :inactive, base_price: 200, restaurant:) }

    it 'returns the category with correct count and average' do
      active_product
      inactive_product
      result = Category.with_products_stats.find(category.id)

      expect(result.products_count).to eq 2
      expect(result.actived_products_count).to eq 1
      expect(result.average_price.to_f).to eq 150
    end
  end
end
