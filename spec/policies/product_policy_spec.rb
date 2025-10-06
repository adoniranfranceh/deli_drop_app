require "rails_helper"

RSpec.describe ProductPolicy do
  describe "#update?" do
    it "allows the owner to update the product of their own restaurant" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      product = create(:product, restaurant:, category: restaurant.categories.first)

      policy = described_class.new(user, product)
      expect(policy.update?).to be true
    end

    it "deny update if it is not your restaurant category" do
      user = create(:restaurant_user)
      other_user = create(:restaurant_user, email: 'other@email.com')
      create(:restaurant, restaurant_user: other_user)
      restaurant = create(:restaurant, restaurant_user: user)
      product = create(:product, restaurant:, category: restaurant.categories.first)

      policy = described_class.new(other_user, product)
      expect(policy.update?).to be false
    end
  end
end
