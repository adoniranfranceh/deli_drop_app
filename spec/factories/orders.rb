FactoryBot.define do
  factory :order do
    association :restaurant
    association :customer

    delivery_address { "Rua das Flores, 123" }
    delivery_neighborhood { "Centro" }
    subtotal { 5000 }
    delivery_fee { 500 }
    discount { 0 }
    total { 5500 }
    payment_method { :pix }
    payment_status { :payment_pending }

    trait :with_items do
      after(:build) do |order|
        product = order.restaurant.products.first ||
                  create(:product, restaurant: order.restaurant,
                         category: order.restaurant.categories.first)

        order.order_items << build(:order_item,
          order: order,
          product: product,
          product_name: product.name,
          unit_price: product.base_price,
          total_price: product.base_price
        )
      end
    end

    trait :confirmed do
      status { :confirmed }
      confirmed_at { Time.current }
    end

    trait :preparing do
      status { :preparing }
      confirmed_at { 5.minutes.ago }
      preparing_at { Time.current }
    end

    trait :cash_payment do
      payment_method { :cash }
      change_for { 10000 }
    end
  end
end
