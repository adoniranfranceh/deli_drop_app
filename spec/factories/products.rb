FactoryBot.define do
  factory :product do
    name { "Combo Mix" }
    base_price { 4990 }
    description { "Este é o combo mais conhecido do mundo" }
    ingredients { [ "Bebidas", "Comidas" ] }
    status { 'active' }
    featured { false }
    duration { 34 }
    image { "http://product_image.png" }

    association :restaurant, factory: :restaurant
    category { association(:category, restaurant:) }
  end
end
