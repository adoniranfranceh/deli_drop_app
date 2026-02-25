FactoryBot.define do
  factory :customer do
    name { "João Silva" }
    sequence(:phone) { |n| "89 9#{n.to_s.rjust(4, '0')}-0000" }
    sequence(:email) { |n| "cliente#{n}@email.com" }
  end
end
