require 'rails_helper'

RSpec.describe "PUT /api/v1/products/:id", type: :request do
  context "when user is logged in" do
    it "updates product including modifier groups and modifiers" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant:)
      product = create(:product, restaurant:, category:, name: "Pizza Margherita", base_price: 4000)
      modifier_group = create(:modifier_group, product:, name: "Tamanhos", input_type: "single_choice", min: 1, max: 1, free_limit: 1)
      modifier = create(:modifier, modifier_group:, name: "Média", base_price: 500)

      payload = {
        product: {
          name: "Pizza Margherita Updated",
          base_price: 4500,
          category_id: category.id,
          modifier_groups_attributes: [
            {
              id: modifier_group.id,
              name: "Tamanhos disponíveis",
              input_type: "multiple_choice",
              min: 2,
              max: 2,
              free_limit: 2,
              modifiers_attributes: [
                {
                  id: modifier.id,
                  name: "Grande",
                  base_price: 500,
                  _destroy: false
                },
                {
                  name: "Pequena",
                  base_price: 0,
                  _destroy: false
                }
              ]
            }
          ]
        }
      }
      login_as user, scope: :restaurant_user

      put api_v1_product_path(product), params: payload

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["product"]["name"]).to eq("Pizza Margherita Updated")
      expect(json_response["product"]["base_price"]).to eq(4500)
      expect(product.modifier_groups.first.name).to eq("Tamanhos disponíveis")
      expect(product.modifier_groups.first.input_type).to eq("multiple_choice")
      expect(product.modifier_groups.first.min).to eq(2)
      expect(product.modifier_groups.first.max).to eq(2)
      expect(product.modifier_groups.first.free_limit).to eq(2)
      modifiers = product.modifier_groups.first.modifiers
      expect(modifiers.first.name).to eq("Grande")
      expect(modifiers.last.name).to eq("Pequena")
      expect(modifiers.first.base_price).to eq(500)
      expect(modifiers.last.base_price).to eq(0)
      expect(modifiers.size).to eq(2)
    end

    it "removes a modifier when _destroy is true" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant: restaurant)
      product = create(:product, restaurant:, category:)
      modifier_group = create(:modifier_group, product:)
      modifier = create(:modifier, modifier_group:)

      payload = {
        product: {
          modifier_groups_attributes: [
            {
              id: modifier_group.id,
              modifiers_attributes: [
                { id: modifier.id, _destroy: true }
              ]
            }
          ]
        }
      }
      login_as user, scope: :restaurant_user

      expect {
        put api_v1_product_path(product), params: payload
      }.to change { Modifier.exists?(modifier.id) }.from(true).to(false)

      expect(response).to have_http_status(:ok)
    end

    it "returns error if required fields are blank" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant:)
      product = create(:product, restaurant:, category: restaurant.categories.first)

      product_params = {
        product: {
          name: ""
        }
      }
      login_as user, scope: :restaurant_user

      put api_v1_product_path(product), params: product_params

      expect(response).to have_http_status(422)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Nome não pode ficar em branco")
    end
  end

  context "when user is not logged in" do
    it "returns unauthorized" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant: restaurant)
      product = create(:product, restaurant: restaurant, category: category, name: "Pizza Margherita", base_price: 4000)

      product_params = {
        product: {
          name: "Pizza",
          category_id: category.id,
          base_price: 20,
          duration: 15,
          description: "Boa pizza",
          image: "https://example.com/pizza.png",
          status: "active",
          featured: false
        }
      }

      put api_v1_product_path(product), params: product_params

      expect(response).to have_http_status(401)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to eq("Você não tem permissão para executar esta ação")
    end
  end

   context "when user tries to update another user's product" do
    it "returns unauthorized" do
      owner = create(:restaurant_user)
      other_user = create(:restaurant_user, email: 'other@email.com')
      create(:restaurant, restaurant_user: other_user)
      restaurant = create(:restaurant, restaurant_user: owner)
      product = create(:product, restaurant:, category: restaurant.categories.first)

      login_as other_user

      put api_v1_product_path(product), params: { product: { name: "Not Allowed" } }

      expect(response).to have_http_status(401)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to eq("Você não tem permissão para executar esta ação")
    end
  end
end
