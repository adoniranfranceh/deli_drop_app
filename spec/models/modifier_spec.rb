require 'rails_helper'

RSpec.describe Modifier, type: :model do
  let(:user)        { create(:restaurant_user) }
  let(:restaurant)  { create(:restaurant, restaurant_user: user) }
  let(:category)    { create(:category, restaurant:) }
  let(:product)     { create(:product, restaurant:, category:) }
  let(:modifier_group) { create(:modifier_group, product:) }

  context 'validations' do
    it 'is invalid without a name' do
      modifier = Modifier.new(modifier_group:, name: nil, base_price: 10, image: 'foto.png')
      expect(modifier).not_to be_valid
      expect(modifier.errors.full_messages).to include("Nome não pode ficar em branco")
    end

    it 'is valid without a base_price' do
      modifier = Modifier.new(modifier_group:, name: 'Cebola extra', base_price: nil, image: 'foto.png')
      expect(modifier).to be_valid
      expect(modifier.errors.full_messages).not_to include("Preço Base não pode ficar em branco")
    end

    it 'is valid without an image' do
      modifier = Modifier.new(modifier_group:, name: 'Cebola extra', base_price: 10, image: nil)
      expect(modifier).to be_valid
      expect(modifier.errors.full_messages).not_to include("Imagem não pode ficar em branco")
    end

    it 'is valid with all required attributes' do
      modifier = Modifier.new(modifier_group:, name: 'Cebola extra', base_price: 10, image: 'foto.png')
      expect(modifier).to be_valid
    end
  end
end
