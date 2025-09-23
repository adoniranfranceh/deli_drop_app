FactoryBot.define do
  factory :category do
    name { "Pizzas" }
    description { "Categoria utilizada para combos" }
    restaurant { nil }
  end
end
