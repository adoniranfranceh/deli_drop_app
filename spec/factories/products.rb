FactoryBot.define do
  factory :product do
    name { "Combo Mix" }
    category { nil }
    base_price { 4990 }
    description { "Este é o combo mais conhecido do mundo" }
    ingredients { [ "Bebidas", "Comidas" ] }
    status { 'active' }
    featured { false }
    restaurant { nil }
    duration { 34 }
    image { "http://product_image.png" }
  end
end
