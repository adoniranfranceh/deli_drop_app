FactoryBot.define do
  factory :restaurant_user do
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "123456" }
  end
end
