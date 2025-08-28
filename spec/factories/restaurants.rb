FactoryBot.define do
  factory :restaurant do
    name { "MyString" }
    culinary_style { 1 }
    description { "MyText" }
    image { "MyString" }
    phone { "MyString" }
    address { "MyString" }
    restaurant_user { nil }
  end
end
