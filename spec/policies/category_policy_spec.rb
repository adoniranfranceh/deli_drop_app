require "rails_helper"

RSpec.describe CategoryPolicy do
  describe "#update?" do
    it "allows the owner to update the category of their own restaurant" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant:)

      policy = described_class.new(user, category)
      expect(policy.update?).to be true
    end

    it "deny update if it is not your restaurant category" do
      user = create(:restaurant_user)
      other_user = create(:restaurant_user, email: 'other@email.com')
      create(:restaurant, restaurant_user: other_user)
      restaurant = create(:restaurant, restaurant_user: user)
      category = create(:category, restaurant:)

      policy = described_class.new(other_user, category)
      expect(policy.update?).to be false
    end
  end
end
