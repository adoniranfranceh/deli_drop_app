require "rails_helper"

RSpec.describe RestaurantPolicy do
  describe "#new?" do
    it "permite criar se usuário não tiver restaurante" do
      user = create(:restaurant_user, restaurant: nil)

      policy = described_class.new(user, Restaurant)
      expect(policy.new?).to be true
    end

    it "nega criar se usuário já tiver restaurante" do
      user = create(:restaurant_user)
      create(:restaurant, restaurant_user: user)

      policy = described_class.new(user, Restaurant)
      expect(policy.new?).to be false
    end
  end

  describe "#edit?" do
    it "permite dono editar seu próprio restaurante" do
      user = create(:restaurant_user)
      restaurant = create(:restaurant, restaurant_user: user)

      policy = described_class.new(user, restaurant)
      expect(policy.edit?).to be true
    end

    it "nega edição se não for o dono" do
      user = create(:restaurant_user)
      other_user = create(:restaurant_user, email: 'other@email.com')
      restaurant = create(:restaurant, restaurant_user: user)

      policy = described_class.new(other_user, restaurant)
      expect(policy.edit?).to be false
    end
  end
end
