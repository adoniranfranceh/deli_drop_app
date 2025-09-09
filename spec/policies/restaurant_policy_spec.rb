require "rails_helper"

RSpec.describe RestaurantPolicy do
  describe "#new?" do
    it "allows creating if user not has restaurant" do
      user = create(:restaurant_user, restaurant: nil)

      policy = described_class.new(user, Restaurant)
      expect(policy.new?).to be true
    end

    it "denies creating if user already has a restaurant" do
      user = create(:restaurant_user)
      create(:restaurant, restaurant_user: user)

      policy = described_class.new(user, Restaurant)
      expect(policy.new?).to be false
    end
  end

  describe "#edit?" do
    it "allows owner editing their own restaurant" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)

      policy = described_class.new(user, restaurant)
      expect(policy.edit?).to be true
    end

    it "denies editing if not the owner" do
      user = create(:restaurant_user)
      other_user = create(:restaurant_user, email: 'other@email.com')
      restaurant = create(:restaurant, restaurant_user: user)

      policy = described_class.new(other_user, restaurant)
      expect(policy.edit?).to be false
    end
  end

  describe "#update?" do
    it "allows owner updating their own restaurant" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)

      policy = described_class.new(user, restaurant)
      expect(policy.update?).to be true
    end

    it "denies updating if not the owner" do
      user = create(:restaurant_user)
      other_user = create(:restaurant_user, email: 'other@email.com')
      restaurant = create(:restaurant, restaurant_user: user)

      policy = described_class.new(other_user, restaurant)
      expect(policy.update?).to be false
    end
  end
end
