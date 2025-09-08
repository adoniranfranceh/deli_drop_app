FactoryBot.define do
  factory :modifier do
    name { "Suco de Maçã" }
    base_price { 1 }
    image { "http://modifier_image.png" }
    modifier_group { nil }
  end
end
