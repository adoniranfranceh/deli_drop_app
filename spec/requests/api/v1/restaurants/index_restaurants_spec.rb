require 'rails_helper'

RSpec.describe "Restaurants API", type: :request do
  describe "GET api/v1/restaurants/" do
    context 'returns only restaurants that have product(s)' do
      include RestaurantJson
      context "without params" do
        it "returns only id, name, description and logo" do
          restaurant1 = create(:restaurant, restaurant_user: create(:restaurant_user),
                              name: 'Restaurante 1', image: 'http://www.restaurant1.com',
                              description: 'The restaurant 1')
          create(:product, restaurant: restaurant1, category: restaurant1.categories.first)
          restaurant2 = create(:restaurant, restaurant_user: create(:restaurant_user),
                              name: 'Restaurante 2', image: 'http://www.restaurant2.com',
                              description: 'The restaurant 2')
          create(:product, restaurant: restaurant2, category: restaurant1.categories.first)
          restaurant3 = create(:restaurant, restaurant_user: create(:restaurant_user),
                              name: 'Restaurante 3', image: 'http://www.restaurant3.com',
                              description: 'The restaurant 3')
          create(:product, restaurant: restaurant3, category: restaurant1.categories.first)
          restaurant4 = create(:restaurant, restaurant_user: create(:restaurant_user),
                              name: 'Restaurante 4', image: 'http://www.restaurant4.com',
                              description: 'The restaurant 4')

          get api_v1_restaurants_path

          expect(response).to have_http_status(:ok)

          json_response = JSON.parse(response.body)
          json_restaurant1 = json_response['restaurants'].first
          json_restaurant2 = json_response['restaurants'].second
          json_restaurant3 = json_response['restaurants'].third
          json_restaurant4 = json_response['restaurants'].fourth

          expect(json_response["meta"]["current_page"]).to eq(1)
          expect(json_response["meta"]["total_count"]).to eq(3)
          expect(json_response["meta"]["total_pages"]).to eq(1)

          expect(Restaurant.count).to eq(4)
          expect(json_response['restaurants'].size).to eq(3)
          expect(json_restaurant1["id"]).to eq(restaurant1.id)
          expect(json_restaurant1["name"]).to eq('Restaurante 1')
          expect(json_restaurant1["description"]).to eq('The restaurant 1')
          expect(json_restaurant1["logo"]).to eq('http://www.restaurant1.com')

          expect(json_restaurant2["id"]).to eq(restaurant2.id)
          expect(json_restaurant2["name"]).to eq('Restaurante 2')
          expect(json_restaurant2["description"]).to eq('The restaurant 2')
          expect(json_restaurant2["logo"]).to eq('http://www.restaurant2.com')

          expect(json_restaurant3["id"]).to eq(restaurant3.id)
          expect(json_restaurant3["name"]).to eq('Restaurante 3')
          expect(json_restaurant3["description"]).to eq('The restaurant 3')
          expect(json_restaurant3["logo"]).to eq('http://www.restaurant3.com')

          expect(json_restaurant4).to be_nil
          json_restaurants = json_response['restaurants'].map(&:deep_symbolize_keys)
          expect(json_restaurants[0]).not_to eq(restaurant_json(restaurant1))
          expect(json_restaurants[1]).not_to eq(restaurant_json(restaurant2))
          expect(json_restaurants[2]).not_to eq(restaurant_json(restaurant3))
        end
      end

      context "when it pass full=true" do
        it "returns full restaurant with categories and products" do
          restaurant_no_products = create(:restaurant, restaurant_user: create(:restaurant_user))
          restaurant = create(:restaurant, restaurant_user: create(:restaurant_user))
          category = create(:category, restaurant:, name: "Pizzas")
          product = create(:product, category:, name: "Pizza Margherita", base_price: 30.0, restaurant:)
          group = create(:modifier_group, product:, name: "Sabores")
          modifier = create(:modifier, modifier_group: group, name: "Extra queijo", base_price: 5.0)

          get api_v1_restaurants_path, params: { full: true }

          expect(response).to have_http_status(:ok)

          json_response = JSON.parse(response.body)
          json_restaurant = json_response['restaurants'].first

          expect(json_response["meta"]["current_page"]).to eq(1)
          expect(json_response["meta"]["total_count"]).to eq(1)
          expect(json_response["meta"]["total_pages"]).to eq(1)

          expect(Restaurant.count).to eq(2)
          json_restaurants = json_response['restaurants'].map(&:deep_symbolize_keys)
          expect(json_restaurants[0]).to eq(restaurant_json(restaurant))
        end
      end

      context "when restaurants have no products" do
        it "does not return restaurants without products unless full=true" do
          restaurant = create(:restaurant, restaurant_user: create(:restaurant_user))

          get api_v1_restaurants_path
          json_response = JSON.parse(response.body)

          expect(json_response['restaurants']).to be_empty
        end
      end

      context "when filtering by query" do
        it "returns restaurants matching the query" do
          r1 = create(:restaurant, name: "Pizza Place", restaurant_user: create(:restaurant_user))
          r2 = create(:restaurant, name: "Burger Joint", restaurant_user: create(:restaurant_user))
          create(:product, restaurant: r1, category: r1.categories.first)
          create(:product, restaurant: r2, category: r2.categories.first)

          get api_v1_restaurants_path, params: { query: "Pizza" }

          json_response = JSON.parse(response.body)
          expect(json_response['restaurants'].size).to eq(1)
          expect(json_response['restaurants'].first['name']).to eq("Pizza Place")
        end
      end

      context "pagination" do
        it "returns the correct meta data" do
          restaurants = create_list(:restaurant, 25)

          restaurants.each do |restaurant|
            create(:product, restaurant: restaurant, category: restaurant.categories.first)
          end

          get api_v1_restaurants_path, params: { per_page: 10, page: 2 }

          json_response = JSON.parse(response.body)
          expect(json_response['restaurants'].size).to eq(10)
          expect(json_response['meta']['current_page']).to eq(2)
          expect(json_response['meta']['total_pages']).to eq(3)
          expect(json_response['meta']['total_count']).to eq(25)
        end
      end
    end
  end
end
