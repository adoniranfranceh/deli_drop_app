require 'rails_helper'

describe "POST /api/v1/categories" do
  let (:user) { create(:restaurant_user) }
  let (:restaurant) { create(:restaurant, restaurant_user: user) }

  before do
    restaurant
  end

  context "when user is logged in" do
    it "creates successfully" do
      category_params = {
        category: {
          name: "Pizzas",
          description: "A test category"
        }
      }
      login_as user

      post api_v1_categories_path, params: category_params

      expect(response).to have_http_status(201)
      json_response = JSON.parse(response.body)
      category_response = json_response["category"]
      expect(category_response["name"]).to eq("Pizzas")
      expect(category_response["description"]).to eq("A test category")
      expect(category_response["restaurant_id"]).to eq(restaurant.id)
    end

    it "returns error if required fields are blank" do
      category_params = {
        category: {
          name: "",
          description: ""
        }
      }
      login_as user

      post api_v1_categories_path, params: category_params

      expect(response).to have_http_status(422)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Nome não pode ficar em branco")
      expect(json_response["errors"]).not_to include("Descrição não pode ficar em branco")
    end

    it "to another restaurant" do
      another_user = create(:restaurant_user, email: 'another@email.com')
      another_restaurant = create(:restaurant, restaurant_user: another_user)
      category_params = {
        category: {
          name: "Pizzas",
          description: "A test category",
          restaurant_id: another_restaurant.id
        }
      }
      login_as user

      post api_v1_categories_path, params: category_params

      expect(response).to have_http_status(201)
      json_response = JSON.parse(response.body)
      category_response = json_response["category"]
      expect(category_response["name"]).to eq("Pizzas")
      expect(category_response["description"]).to eq("A test category")
      expect(category_response["restaurant_id"]).to eq(restaurant.id)
    end
  end

  context "when user is not logged in" do
    it "returns unprocessable entity" do
      category_params = {
        category: {
          name: "Pizzas",
          description: "A test category"
        }
      }

      post api_v1_categories_path, params: category_params

      expect(response).to have_http_status(422)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Restaurante é obrigatório(a)")
    end
  end
end
