FactoryBot.define do
  factory :order_item_modifier do
    association :order_item

    group_name { "Tamanho" }
    modifier_name { "Grande" }
    unit_price { 500 }
    quantity { 1 }
  end
end
