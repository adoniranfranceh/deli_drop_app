require 'rails_helper'

RSpec.describe RestaurantQuery do
  describe '#call' do
    it 'returns all restaurants when there are no filters' do
      restaurant1 = create(:restaurant, name: 'Pizzaria Dony')
      restaurant2 = create(:restaurant, name: 'Sushi Place')
      restaurant3 = create(:restaurant, name: 'Hamburgueria 123')

      create(:product, restaurant: restaurant1, category: restaurant1.categories.first)
      create(:product, restaurant: restaurant2, category: restaurant2.categories.first)
      create(:product, restaurant: restaurant3, category: restaurant3.categories.first)

      response = described_class.new({}).call

      expect(response).to match_array([ restaurant1, restaurant2, restaurant3 ])
    end

    context 'returns restaurants whose' do
      it 'restaurant name matches the query' do
        restaurant1 = create(:restaurant, name: 'Pizzaria Dony')
        restaurant2 = create(:restaurant, name: 'Sushi Place')

        create(:product, restaurant: restaurant1, category: restaurant1.categories.first)
        create(:product, restaurant: restaurant2, category: restaurant2.categories.first)

        response = described_class.new({ query: 'piz' }).call

        expect(response).to contain_exactly(restaurant1)
      end

      it 'restaurant description matches the query' do
        restaurant1 = create(:restaurant, description: 'Pizza artesanal')
        restaurant2 = create(:restaurant, description: 'Comida japonesa')

        create(:product, restaurant: restaurant1, category: restaurant1.categories.first)
        create(:product, restaurant: restaurant2, category: restaurant2.categories.first)

        response = described_class.new({ query: 'piz' }).call

        expect(response).to contain_exactly(restaurant1)
      end

      it 'product name matches the query' do
        restaurant1 = create(:restaurant)
        restaurant2 = create(:restaurant)

        create(:product, name: 'Pizza de Calabresa', restaurant: restaurant1, category: restaurant1.categories.first)
        create(:product, name: 'Pizza', restaurant: restaurant2, category: restaurant2.categories.first)

        response = described_class.new({ query: 'Calabresa' }).call

        expect(response).to contain_exactly(restaurant1)
      end

      it 'product description matches the query' do
        restaurant1 = create(:restaurant)
        restaurant2 = create(:restaurant)

        create(:product, description: 'Deliciosa Pizza de Calabresa', restaurant: restaurant1, category: restaurant1.categories.first)
        create(:product, description: 'Deliciosa Pizza', restaurant: restaurant2, category: restaurant2.categories.first)

        response = described_class.new({ query: 'Calabresa' }).call

        expect(response).to contain_exactly(restaurant1)
      end

      it 'product ingredients matches the query' do
        restaurant1 = create(:restaurant)
        restaurant2 = create(:restaurant)

        create(:product, ingredients: [ 'Molho Italiano', 'Calabresa' ], restaurant: restaurant1, category: restaurant1.categories.first)
        create(:product, ingredients: [ 'Cream Cheese', 'Cebola' ], restaurant: restaurant2, category: restaurant2.categories.first)

        response = described_class.new({ query: 'Calabresa' }).call

        expect(response).to contain_exactly(restaurant1)
      end
    end

    it 'returns restaurants by product category' do
      restaurant1 = create(:restaurant, name: 'Pizzaria Dony')
      restaurant2 = create(:restaurant, name: 'Sushi Place')

      category = create(:category, name: 'Japonesa', restaurant: restaurant1)
      create(:product, restaurant: restaurant2, category: category)

      response = described_class.new({ category: 'Japone' }).call

      expect(response).to contain_exactly(restaurant2)
    end

    it 'returns the items on the correct page when pagination is present' do
      restaurants = create_list(:restaurant, 25)
      restaurants.each do |restaurant|
        create(:product, restaurant:, category: restaurant.categories.first)
      end

      response = described_class.new({ page: 2, per_page: 10 }).call

      expect(response.current_page).to eq(2)
      expect(response.size).to eq(10)
      expect(response.total_count).to eq(25)
    end
  end
end
