require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  let(:user) { create(:restaurant_user) }

  context '.valid' do
    it 'is invalid without a name' do
      restaurant = Restaurant.new(name: nil)
      expect(restaurant).not_to be_valid
      expect(restaurant.errors.full_messages).to include("Nome não pode ficar em branco")
    end

    it 'is invalid without a culinary_style' do
      restaurant = Restaurant.new(culinary_style: nil)
      expect(restaurant).not_to be_valid
      expect(restaurant.errors.full_messages).to include("Tipo de Culinária não pode ficar em branco")
    end

    it 'is invalid without a description' do
      restaurant = Restaurant.new(description: nil)
      expect(restaurant).not_to be_valid
      expect(restaurant.errors.full_messages).to include("Descrição não pode ficar em branco")
    end

    it 'is invalid without a image' do
      restaurant = Restaurant.new(image: nil)
      expect(restaurant).not_to be_valid
      expect(restaurant.errors.full_messages).to include("Imagem não pode ficar em branco")
    end

    it 'is invalid without a phone' do
      restaurant = Restaurant.new(phone: nil)
      expect(restaurant).not_to be_valid
      expect(restaurant.errors.full_messages).to include("Telefone não pode ficar em branco")
    end

    it 'enforces uniqueness of restaurant_user_id' do
      create(:restaurant, restaurant_user: user)
      duplicate = Restaurant.new(restaurant_user: user)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors.full_messages).to include("Usuário Restaurante já está em uso")
    end
  end
end
