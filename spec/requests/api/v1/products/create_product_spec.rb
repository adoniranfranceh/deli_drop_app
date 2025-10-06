require "rails_helper"

describe "POST /api/v1/products" do
  context "when user is logged in" do
    it "creates successfully" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant: restaurant)

      product_params = {
        product: {
          name: "Pizza Margherita",
          category_id: category.id,
          base_price: 25.0,
          duration: 30,
          description: "Clássica pizza italiana",
          image: "https://example.com/pizza.png",
          status: "active",
          featured: true
        }
      }
      login_as user

      post api_v1_products_path, params: product_params

      expect(response).to have_http_status(201)
      json_response = JSON.parse(response.body)
      product_response = json_response["product"]

      expect(product_response["name"]).to eq("Pizza Margherita")
      expect(product_response["category_id"]).to eq(category.id)
      expect(product_response["restaurant_id"]).to eq(restaurant.id)
      expect(product_response["description"]).to eq("Clássica pizza italiana")
    end

    it "returns error if required fields are blank" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant: restaurant)

      product_params = {
        product: {
          name: "",
          category_id: nil,
          base_price: nil,
          duration: nil,
          description: "",
          image: "",
          status: "",
          featured: nil
        }
      }
      login_as user

      post api_v1_products_path, params: product_params

      expect(response).to have_http_status(422)
      json_response = JSON.parse(response.body)

      expect(json_response["errors"]).to include("Nome não pode ficar em branco")
      expect(json_response["errors"]).to include("Categoria não pode ficar em branco")
      expect(json_response["errors"]).to include("Preço Base não pode ficar em branco")
      expect(json_response["errors"]).to include("Tempo de Preparo não pode ficar em branco")
      expect(json_response["errors"]).to include("Descrição não pode ficar em branco")
      expect(json_response["errors"]).not_to include("Imagem não pode ficar em branco")
      expect(json_response["errors"]).to include("Status não pode ficar em branco")
      expect(json_response["errors"]).to include("Produto em Destaque não está incluído na lista")
    end
  end

  context "when user is not logged in" do
    it "returns unauthorized" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant: restaurant)

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

      post api_v1_products_path, params: product_params

      expect(response).to have_http_status(422)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Restaurante é obrigatório(a)")
    end
  end
end
