FactoryBot.define do
  factory :order_item do
    association :order
    association :product

    product_name { "X-Burguer" }
    product_image { "http://product_image.png" }
    unit_price { 2500 }
    quantity { 1 }
    total_price { 2500 }
  end
end
