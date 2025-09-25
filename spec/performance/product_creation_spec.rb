require 'rails_helper'
require 'benchmark'

RSpec.describe "Product creation performance", type: :performance do
  it "creates product with many modifier_groups and modifiers in acceptable time" do
    restaurant_user = create(:restaurant_user)
    restaurant = create(:restaurant, restaurant_user:)
    category   = create(:category, restaurant:)

    modifier_groups_attrs = Array.new(20) do |i|
      {
        name: "Grupo #{i}",
        input_type: :multiple_choice,
        min: 0,
        max: 30,
        free_limit: 30,
        modifiers_attributes: Array.new(30) do |j|
          {
            name: "Modificador #{i}-#{j}",
            base_price: rand(1.0..10.0),
            image: "http://example.com/modificador-#{i}-#{j}.png"
          }
        end
      }
    end

    product_attrs = {
      name: "Pizza Gigante",
      base_price: 50.0,
      duration: 30,
      description: "Pizza com muitos modificadores",
      status: :active,
      featured: true,
      category: category,
      restaurant: restaurant,
      modifier_groups_attributes: modifier_groups_attrs
    }

    elapsed = Benchmark.realtime do
      product = Product.create!(product_attrs)
      expect(product.modifier_groups.count).to eq(20)
      expect(product.modifier_groups.first.modifiers.count).to eq(30)
    end

    expect(elapsed).to be < 1
  end
end
