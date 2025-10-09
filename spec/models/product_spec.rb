require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:category)   { create(:category, restaurant:) }

  context '.valid' do
    it 'is invalid without a name' do
      product = Product.new(name: nil, category: category, restaurant: restaurant,
                            base_price: 1000, duration: 10, description: 'Teste',
                            status: :active, featured: true)
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Nome não pode ficar em branco")
    end

    it 'is invalid without a category' do
      product = Product.new(name: 'Pizza', category: nil, restaurant: restaurant,
                            base_price: 1000, duration: 10, description: 'Teste',
                            status: :active, featured: true)
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Categoria não pode ficar em branco")
    end

    it 'is invalid without a base_price' do
      product = Product.new(name: 'Pizza', category: category, restaurant: restaurant,
                            base_price: nil, duration: 10, description: 'Teste',
                            status: :active, featured: true)
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Preço Base não pode ficar em branco")
    end

    it 'is invalid without a duration' do
      product = Product.new(name: 'Pizza', category: category, restaurant: restaurant,
                            base_price: 1000, duration: nil, description: 'Teste',
                            status: :active, featured: true)
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Tempo de Preparo não pode ficar em branco")
    end

    it 'is invalid without a description' do
      product = Product.new(name: 'Pizza', category: category, restaurant: restaurant,
                            base_price: 1000, duration: 10, description: nil,
                            status: :active, featured: true)
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Descrição não pode ficar em branco")
    end

    it 'is invalid without a status' do
      product = Product.new(name: 'Pizza', category: category, restaurant: restaurant,
                            base_price: 1000, duration: 10, description: 'Teste',
                            status: nil, featured: true)
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Status não pode ficar em branco")
    end

    it 'is invalid without featured flag' do
      product = Product.new(name: 'Pizza', category: category, restaurant: restaurant,
                            base_price: 1000, duration: 10, description: 'Teste',
                            status: :active, featured: nil)
      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Produto em Destaque não está incluído na lista")
    end

    it 'is valid with all attributes' do
      product = Product.new(name: 'Pizza', category: category, restaurant: restaurant,
                            base_price: 1000, duration: 10, description: 'Teste',
                            status: :active, featured: true)
      expect(product).to be_valid
    end

    it "is invalid if product belongs to a different restaurant than its category" do
      restaurant1 = create(:restaurant)
      restaurant2 = create(:restaurant)
      category = create(:category, restaurant: restaurant1)
      product = Product.new(category: category, restaurant: restaurant2)

      expect(product).not_to be_valid
      expect(product.errors.full_messages).to include("Categoria deve pertencer ao mesmo restaurante que o produto")
    end
  end

  context '.with_category_name' do
    let(:category) { create(:category, restaurant:, name: 'Pizza') }
    let(:product) { create(:product, category:, status: :active, base_price: 100, restaurant:) }

    it 'returns the product with category_name' do
      result = Product.with_category_name.find(product.id)

      expect(result.category_name).to eq 'Pizza'
    end
  end
end
