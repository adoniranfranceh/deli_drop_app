require 'rails_helper'

RSpec.describe ProductQuery do
  describe '#call' do
    it 'returns all products when there are no filters' do
      product1 = create(:product)
      product2 = create(:product)
      product3 = create(:product)

      response = described_class.new({}).call

      expect(response).to match_array([ product1, product2, product3 ])
    end

    context 'returns products whose' do
      it 'product name matches the query' do
        product1 = create(:product, name: 'Pizza de Calabresa')
        create(:product, name: 'Pizza')

        response = described_class.new({ query: 'Calabresa' }).call

        expect(response).to contain_exactly(product1)
      end

      it 'product description matches the query' do
        product1 = create(:product, description: 'Deliciosa Pizza de Calabresa')
        create(:product, description: 'Deliciosa Pizza')

        response = described_class.new({ query: 'Calabresa' }).call

        expect(response).to contain_exactly(product1)
      end

      it 'product ingredients matches the query' do
        product1 = create(:product, ingredients: [ 'Molho Italiano', 'Calabresa' ])
        create(:product, ingredients: [ 'Cream Cheese', 'Cebola' ])

        response = described_class.new({ query: 'Calabresa' }).call

        expect(response).to contain_exactly(product1)
      end
    end

    it 'return products by its category' do
      restaurant = create(:restaurant)
      product1 = create(:product, name: 'Pizza', restaurant:)
      product2 = create(:product, name: 'Sushi', restaurant:,
                                  category: create(:category, name: 'Japonesa', restaurant:))

      response = described_class.new({ category: 'Japone' }).call

      expect(response).to contain_exactly(product2)
    end

    it 'returns the items on the correct page when pagination is present' do
      products = create_list(:product, 25)

      response = described_class.new({ page: 2, per_page: 10 }).call

      expect(response.current_page).to eq(2)
      expect(response.size).to eq(10)
      expect(response.total_count).to eq(25)
    end
  end
end
