require 'rails_helper'

describe "POST /api/v1/restaurants" do
  context "when user is logged in" do
    it "creates successfully" do
      user = create(:restaurant_user)
      restaurant_params = {
        restaurant: {
          name: "Testaurant",
          culinary_style: "italian",
          description: "A test restaurant",
          image: 'https://example.com/image.jpg',
          phone: "123-456-7890",
          address: "123 Test St"
        }
      }
      login_as user

      post api_v1_restaurants_path, params: restaurant_params

      expect(response).to have_http_status(201)
      json_response = JSON.parse(response.body)
      restaurant_response = json_response["restaurant"]
      expect(restaurant_response["name"]).to eq("Testaurant")
      expect(restaurant_response["address"]).to eq("123 Test St")
      expect(restaurant_response["phone"]).to eq("123-456-7890")
      expect(restaurant_response["description"]).to eq("A test restaurant")
      expect(restaurant_response["restaurant_user_id"]).to eq(user.id)
    end

    it "returns error if required fields are blank" do
      user = create(:restaurant_user)
      restaurant_params = {
        restaurant: {
          name: "",
          culinary_style: "",
          description: "",
          image: '',
          phone: "",
          address: ""
        }
      }
      login_as user

      post api_v1_restaurants_path, params: restaurant_params

      expect(response).to have_http_status(422)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Nome não pode ficar em branco")
      expect(json_response["errors"]).to include("Tipo de Culinária não pode ficar em branco")
      expect(json_response["errors"]).to include("Descrição não pode ficar em branco")
      expect(json_response["errors"]).to include("Imagem não pode ficar em branco")
      expect(json_response["errors"]).to include("Telefone não pode ficar em branco")
      expect(json_response["errors"]).not_to include("Endereço não pode ficar em branco")
    end
  end

  context "when user is not logged in" do
    it "returns unauthorized" do
      restaurant_params = {
        restaurant: {
          name: "Testaurant",
          culinary_style: "italian",
          description: "A test restaurant",
          image: 'https://example.com/image.jpg',
          phone: "123-456-7890",
          address: "123 Test St"
        }
      }

      post api_v1_restaurants_path, params: restaurant_params

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json_response["errors"]).to eq("Usuário Restaurante é obrigatório(a)")
    end
  end

  context "when it cannot create" do
    it "when restaurant_user already has a restaurant" do
      user = create(:restaurant_user)
      create(:restaurant, restaurant_user: user)
      restaurant_params = {
        restaurant: {
          name: "Testaurant",
          culinary_style: "italian",
          description: "A test restaurant",
          image: 'https://example.com/image.jpg',
          phone: "123-456-7890",
          address: "123 Test St"
        }
      }
      login_as user

      post api_v1_restaurants_path, params: restaurant_params

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json_response["errors"]).to include("Usuário Restaurante já está em uso")
    end
  end
end
