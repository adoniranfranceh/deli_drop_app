FactoryBot.define do
  factory :category do
    name { "Combos" }
    description { "Categoria utilizada para combos" }
    restaurant { nil }
  end
end
