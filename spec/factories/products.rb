FactoryBot.define do
  factory :product do
    name { "MyString" }
    category { nil }
    base_price { 1000 }
    description { "MyText" }
    ingredients { "MyString" }
    status { 'active' }
    featured { false }
    restaurant { nil }
    duration { 1 }
    image { "MyString" }
  end
end
