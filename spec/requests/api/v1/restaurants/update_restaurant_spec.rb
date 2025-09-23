require 'rails_helper'

describe "PATCH /api/v1/restaurants/:id" do
  context "when user is logged in" do
    it "updates successfully" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)

      update_params = {
        restaurant: {
          name: "Updated Name",
          culinary_style: "japanese",
          description: "Updated description",
          image: "https://example.com/new-image.jpg",
          phone: "987-654-3210",
          address: "456 Updated St"
        }
      }

      login_as user

      patch api_v1_restaurant_path(restaurant), params: update_params

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      restaurant_response = json_response["restaurant"]

      expect(restaurant_response["name"]).to eq("Updated Name")
      expect(restaurant_response["culinary_style"]).to eq("japanese")
      expect(restaurant_response["description"]).to eq("Updated description")
      expect(restaurant_response["image"]).to eq("https://example.com/new-image.jpg")
      expect(restaurant_response["phone"]).to eq("987-654-3210")
      expect(restaurant_response["address"]).to eq("456 Updated St")
    end

    it "returns error if required fields are blank" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)

      update_params = {
        restaurant: {
          name: "",
          culinary_style: "",
          description: "",
          image: "",
          phone: "",
          address: ""
        }
      }

      login_as user

      patch api_v1_restaurant_path(restaurant), params: update_params

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
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)

      update_params = {
        restaurant: { name: "Hack Attempt" }
      }

      patch api_v1_restaurant_path(restaurant), params: update_params

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(401)
      expect(json_response["errors"]).to eq("Você não tem permissão para executar esta ação")
    end
  end

  context "when user tries to update another user's restaurant" do
    it "returns unauthorized" do
      owner = create(:restaurant_user)
      other_user = create(:restaurant_user, email: 'other@email.com')
      create(:restaurant, restaurant_user: other_user)
      restaurant = create(:restaurant, restaurant_user: owner)

      login_as other_user

      patch api_v1_restaurant_path(restaurant), params: { restaurant: { name: "Not Allowed" } }

      expect(response).to have_http_status(401)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to eq("Você não tem permissão para executar esta ação")
    end
  end
end
