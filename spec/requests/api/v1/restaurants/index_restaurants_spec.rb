require 'rails_helper'

RSpec.describe "Restaurants API", type: :request do
  describe "GET api/v1/restaurants/" do
    context 'returns only restaurants that have product(s)' do
      context "when it doesn't pass full=true" do
        it "returns only id, name and logo" do
          restaurant1 = create(:restaurant, restaurant_user: create(:restaurant_user),
                              name: 'Restaurante 1', image: 'http://www.restaurant1.com')
          create(:product, restaurant: restaurant1, category: restaurant1.categories.first)
          restaurant2 = create(:restaurant, restaurant_user: create(:restaurant_user),
                              name: 'Restaurante 2', image: 'http://www.restaurant2.com')
          create(:product, restaurant: restaurant2, category: restaurant1.categories.first)
          restaurant3 = create(:restaurant, restaurant_user: create(:restaurant_user),
                              name: 'Restaurante 3', image: 'http://www.restaurant3.com')
          create(:product, restaurant: restaurant3, category: restaurant1.categories.first)
          restaurant4 = create(:restaurant, restaurant_user: create(:restaurant_user),
                              name: 'Restaurante 4', image: 'http://www.restaurant4.com')

          get api_v1_restaurants_path

          expect(response).to have_http_status(:ok)

          json_response = JSON.parse(response.body)
          json_restaurant1 = json_response.first
          json_restaurant2 = json_response.second
          json_restaurant3 = json_response.third
          json_restaurant4 = json_response.fourth

          expect(json_response.size).to eq(3)
          expect(json_restaurant1["id"]).to eq(restaurant1.id)
          expect(json_restaurant1["name"]).to eq('Restaurante 1')
          expect(json_restaurant1["logo"]).to eq('http://www.restaurant1.com')

          expect(json_restaurant2["id"]).to eq(restaurant2.id)
          expect(json_restaurant2["name"]).to eq('Restaurante 2')
          expect(json_restaurant2["logo"]).to eq('http://www.restaurant2.com')

          expect(json_restaurant3["id"]).to eq(restaurant3.id)
          expect(json_restaurant3["name"]).to eq('Restaurante 3')
          expect(json_restaurant3["logo"]).to eq('http://www.restaurant3.com')

          expect(json_restaurant4).to be_nil
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
          json_restaurant = json_response.first

          expect(json_response.size).to eq(1)
          expect(json_restaurant["id"]).to eq(restaurant.id)
          expect(json_restaurant["name"]).to eq(restaurant.name)
          expect(json_restaurant["logo"]).to eq(restaurant.image)

          expect(json_restaurant["categories"]).to be_present
          json_category = json_restaurant["categories"].first
          expect(json_category["name"]).to eq("Pizzas")

          json_product = json_category["products"].first
          expect(json_product["name"]).to eq("Pizza Margherita")
          expect(json_product["base_price"]).to eq(30)

          json_group = json_product["modifier_groups"].first
          expect(json_group["name"]).to eq("Sabores")

          json_modifier = json_group["modifiers"].first
          expect(json_modifier["name"]).to eq("Extra queijo")
          expect(json_modifier["base_price"]).to eq(5)
        end
      end
    end
  end
end
