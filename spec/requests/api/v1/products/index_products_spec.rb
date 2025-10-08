require 'rails_helper'

RSpec.describe "Products API" do
  describe "GET api/v1/products/" do
    context "returns products" do
      include ProductJson
       context "without params" do
        it "returns only id, restaurant_id, name, description, image and base_price" do
          restaurant = create(:restaurant)
          category1 = create(:category, name: 'Category 1', restaurant:)
          product1 = create(:product, name: 'Product 1', description: 'The product 1',
                                      image: 'http://www.product1.com', base_price: 2000,
                                      category: category1, restaurant:)

          category2 = create(:category, name: 'Category 2', restaurant:)
          product2 = create(:product, name: 'Product 2', description: 'The product 2',
                                      image: 'http://www.product2.com', base_price: 3000,
                                      category: category2, restaurant:)

          category3 = create(:category, name: 'Category 3', restaurant:)
          product3 = create(:product, name: 'Product 3', description: 'The product 3',
                                      image: 'http://www.product3.com', base_price: 4000,
                                      category: category3, restaurant:)

          get api_v1_products_path

          expect(response).to have_http_status(:ok)

          json_response = JSON.parse(response.body)
          json_product1 = json_response['products'].first
          json_product2 = json_response['products'].second
          json_product3 = json_response['products'].third

          expect(json_response["meta"]["current_page"]).to eq(1)
          expect(json_response["meta"]["total_count"]).to eq(3)
          expect(json_response["meta"]["total_pages"]).to eq(1)

          expect(Product.count).to eq(3)
          expect(json_response['products'].size).to eq(3)
          expect(json_product1["id"]).to eq(product1.id)
          expect(json_product1["restaurant_id"]).to eq(product1.restaurant_id)
          expect(json_product1["name"]).to eq('Product 1')
          expect(json_product1["category"]).to eq('Category 1')
          expect(json_product1["description"]).to eq('The product 1')
          expect(json_product1["image"]).to eq('http://www.product1.com')
          expect(json_product1["base_price"]).to eq(2000)

          expect(json_product2["id"]).to eq(product2.id)
          expect(json_product2["restaurant_id"]).to eq(product2.restaurant_id)
          expect(json_product2["name"]).to eq('Product 2')
          expect(json_product2["category"]).to eq('Category 2')
          expect(json_product2["description"]).to eq('The product 2')
          expect(json_product2["image"]).to eq('http://www.product2.com')
          expect(json_product2["base_price"]).to eq(3000)

          expect(json_product3["id"]).to eq(product3.id)
          expect(json_product3["restaurant_id"]).to eq(product3.restaurant_id)
          expect(json_product3["name"]).to eq('Product 3')
          expect(json_product3["category"]).to eq('Category 3')
          expect(json_product3["description"]).to eq('The product 3')
          expect(json_product3["image"]).to eq('http://www.product3.com')
          expect(json_product3["base_price"]).to eq(4000)

          json_products = json_response['products'].map(&:deep_symbolize_keys)
          expect(json_products[0]).not_to eq(product_json(product1))
          expect(json_products[1]).not_to eq(product_json(product2))
          expect(json_products[2]).not_to eq(product_json(product3))
        end
      end

      context "when it pass full=true" do
        it "returns full product with modifiers_group and its modifiers" do
          product1 = create(:product, name: 'Product 1', description: 'The product 1',
                                      image: 'http://www.product1.com', base_price: 2000)
          modifier_group1 = create(:modifier_group, product: product1)
          create(:modifier, modifier_group: modifier_group1)
          product2 = create(:product, name: 'Product 2', description: 'The product 2',
                                      image: 'http://www.product2.com', base_price: 3000)
          modifier_group2 = create(:modifier_group, product: product2)
          create(:modifier, modifier_group: modifier_group2)
          product3 = create(:product, name: 'Product 3', description: 'The product 3',
                                      image: 'http://www.product3.com', base_price: 4000)
          modifier_group3 = create(:modifier_group, product: product3)
          create(:modifier, modifier_group: modifier_group3)

          get api_v1_products_path, params: { full: true }

          expect(response).to have_http_status(:ok)

          json_response = JSON.parse(response.body)
          json_product1 = json_response['products'].first
          json_product2 = json_response['products'].second
          json_product3 = json_response['products'].third

          expect(json_response["meta"]["current_page"]).to eq(1)
          expect(json_response["meta"]["total_count"]).to eq(3)
          expect(json_response["meta"]["total_pages"]).to eq(1)

          expect(Product.count).to eq(3)
          json_products = json_response['products'].map(&:deep_symbolize_keys)
          expect(json_products[0]).to eq(product_json(product1))
          expect(json_products[1]).to eq(product_json(product2))
          expect(json_products[2]).to eq(product_json(product3))
        end
      end

      context "when filtering by query" do
        it "returns products matching the name" do
          product1 = create(:product, name: "Pizza de Calabresa")
          create(:product, name: "Pizza Margherita")

          get api_v1_products_path, params: { query: "Calabresa" }

          json_response = JSON.parse(response.body)
          expect(json_response['products'].size).to eq(1)
          expect(json_response['products'].first['name']).to eq("Pizza de Calabresa")
        end

        it "returns products matching the description" do
          product1 = create(:product, description: "Deliciosa Pizza de Calabresa")
          create(:product, description: "Deliciosa Pizza")

          get api_v1_products_path, params: { query: "Calabresa" }

          json_response = JSON.parse(response.body)
          expect(json_response['products'].size).to eq(1)
          expect(json_response['products'].first['description']).to eq("Deliciosa Pizza de Calabresa")
        end

        it "returns products matching ingredients" do
          product1 = create(:product, ingredients: [ "Molho Italiano", "Calabresa" ])
          create(:product, ingredients: [ "Cream Cheese", "Cebola" ])

          get api_v1_products_path, params: { query: "Calabresa" }

          json_response = JSON.parse(response.body)
          expect(json_response['products'].size).to eq(1)
          expect(json_response['products'].first['id']).to eq(product1.id)
        end
      end

      context "when filtering by category" do
        it "returns products by category name" do
          restaurant = create(:restaurant)
          category = create(:category, name: "Japonesa", restaurant:)
          product1 = create(:product, name: "Sushi", category: category, restaurant:)

          create(:product, name: "Pizza", restaurant:)

          get api_v1_products_path, params: { category: "Japone" }

          json_response = JSON.parse(response.body)
          expect(json_response['products'].size).to eq(1)
          expect(json_response['products'].first['id']).to eq(product1.id)
        end
      end

      context "pagination" do
        it "returns the correct meta data" do
          products = create_list(:product, 25)

          get api_v1_products_path, params: { per_page: 10, page: 2 }

          json_response = JSON.parse(response.body)
          expect(json_response['products'].size).to eq(10)
          expect(json_response['meta']['current_page']).to eq(2)
          expect(json_response['meta']['total_pages']).to eq(3)
          expect(json_response['meta']['total_count']).to eq(25)
        end
      end
    end
  end
end
