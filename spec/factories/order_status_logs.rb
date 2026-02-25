FactoryBot.define do
  factory :order_status_log do
    association :order

    from_status { 0 }
    to_status { 5 }
    changed_by { "restaurant" }
  end
end
