require 'rails_helper'

RSpec.describe Category, type: :model do
   let(:user) { create(:restaurant_user) }
   let(:restaurant) { create(:restaurant, restaurant_user: user) }

  context '.valid' do
    it 'is invalid without a name' do
      category = Category.new(name: nil, restaurant: restaurant, description: "Bebidas diversas")
      expect(category).not_to be_valid
      expect(category.errors.full_messages).to include("Nome não pode ficar em branco")
    end

    it 'is valid without a description' do
      category = Category.new(description: nil, restaurant: restaurant, name: "Bebidas")
      expect(category).to be_valid
      expect(category.errors.full_messages).not_to include("Descrição não pode ficar em branco")
    end
  end
end
