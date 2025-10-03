require 'rails_helper'

RSpec.describe "Restaurants API", type: :request do
  describe "GET api/v1/restaurants/:id" do
    let(:user) { create(:restaurant_user) }
    let(:restaurant) { create(:restaurant, restaurant_user: user) }
    let(:product) { create(:product, category: restaurant.categories.first, restaurant:) }
    let(:modifier_group) { create(:modifier_group, product:) }
    let(:modifier) { create(:modifier, modifier_group:) }

    it "return the restaurant with categories e your products" do
      category = restaurant.categories.first
      product
      modifier_group
      modifier
      get api_v1_restaurant_path(restaurant)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["id"]).to eq(restaurant.id)
      expect(json["name"]).to eq(restaurant.name)
      expect(json["description"]).to eq(restaurant.description)
      expect(json["logo"]).to eq(restaurant.image)
      expect(json["categories"]).not_to be_empty

      json_category = json["categories"].first
      expect(json_category["id"]).to eq(category.id)
      expect(json_category["name"]).to eq(category.name)
      expect(json_category["products"]).not_to be_empty

      json_product = json_category["products"].first
      expect(json_product["id"]).to eq(product.id)
      expect(json_product["restaurant_id"]).to eq(restaurant.id)
      expect(json_product["name"]).to eq(product.name)
      expect(json_product["duration"]).to eq(product.duration)
      expect(json_product["base_price"]).to eq(product.base_price)
      expect(json_product["description"]).to eq(product.description)
      expect(json_product["image"]).to eq(product.image)
      expect(json_product["category"]).to eq(category.name)
      expect(json_product["modifier_groups"]).not_to be_empty

      json_modifier_group = json_product["modifier_groups"].first
      expect(json_modifier_group["id"]).to eq(modifier_group.id)
      expect(json_modifier_group["product_id"]).to eq(modifier_group.product_id)
      expect(json_modifier_group["name"]).to eq(modifier_group.name)
      expect(json_modifier_group["input_type"]).to eq(modifier_group.input_type)
      expect(json_modifier_group["min"]).to eq(modifier_group.min)
      expect(json_modifier_group["max"]).to eq(modifier_group.max)
      expect(json_modifier_group["free_limit"]).to eq(modifier_group.free_limit)
      expect(json_modifier_group["modifiers"]).not_to be_empty
      expect(json_modifier_group).not_to have_key("restaurant_id")

      json_modifier = json_modifier_group["modifiers"].first
      expect(json_modifier["id"]).to eq(modifier.id)
      expect(json_modifier["name"]).to eq(modifier.name)
      expect(json_modifier["base_price"]).to eq(modifier.base_price)
      expect(json_modifier["image"]).to eq(modifier.image)
      expect(json_modifier["modifier_group_id"]).to eq(modifier_group.id)
      expect(json_modifier).not_to have_key("product_id")
    end

    it 'returns only categories that have a product' do
      category_cool = restaurant.categories.first
      create(:product, category: restaurant.categories.second, restaurant:)
      create_list(:product, 3, category: category_cool, restaurant:)

      get api_v1_restaurant_path(restaurant)

      expect(Category.count).to eq(4)
      expect(Product.count).to eq(4)
      json = JSON.parse(response.body)
      expect(json["categories"].size).to eq(2)
      expect(json["categories"].first["products"].size).to eq(3)
      expect(json["categories"].second["products"].size).to eq(1)
    end
  end
end
