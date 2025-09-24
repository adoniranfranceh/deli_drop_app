require 'rails_helper'

describe "PATCH /api/v1/categories/:id" do
  context "when user is logged in" do
    it "updates successfully" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant:)

      update_params = {
        category: {
          name: "Updated Name",
          description: "Updated description"
        }
      }

      login_as user

      patch api_v1_category_path(category), params: update_params

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      category_response = json_response["category"]

      expect(category_response["name"]).to eq("Updated Name")
      expect(category_response["description"]).to eq("Updated description")
      expect(category_response["products_count"]).to eq(0)
      expect(category_response["actived_products_count"]).to eq(0)
      expect(category_response["average_price"].to_f).to eq(0.0)
      expect(category_response["restaurant_id"]).to eq(restaurant.id)
    end

    it "returns error if required fields are blank" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant:)

      update_params = {
        category: {
          name: "",
          description: ""
        }
      }

      login_as user

      patch api_v1_category_path(category), params: update_params

      expect(response).to have_http_status(422)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Nome não pode ficar em branco")
      expect(json_response["errors"]).not_to include("Descrição não pode ficar em branco")
    end
  end

  context "when user is not logged in" do
    it "returns unauthorized" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant:)

      update_params = {
        category: { name: "Hack Attempt" }
      }

      patch api_v1_category_path(category), params: update_params

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
      category = create(:category, restaurant:)

      login_as other_user

      patch api_v1_category_path(category), params: { restaurant: { name: "Not Allowed" } }

      expect(response).to have_http_status(401)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to eq("Você não tem permissão para executar esta ação")
    end
  end
end
