FactoryBot.define do
  factory :modifier_group do
    association :product
    name { "Escolha uma bebida" }
    input_type { :single_choice }
    min { 1 }
    max { 1 }
    free_limit { 1 }
  end
end
