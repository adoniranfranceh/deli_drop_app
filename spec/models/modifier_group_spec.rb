require 'rails_helper'

RSpec.describe ModifierGroup, type: :model do
  let(:user) { create(:restaurant_user) }
  let(:restaurant) { create(:restaurant, restaurant_user: user) }
  let(:category)   { create(:category, restaurant:) }
  let(:product) { create(:product, restaurant:, category:) }

  context '.validations' do
    context 'presence validations' do
      it 'is invalid without a name' do
        modifier_group = ModifierGroup.new(product: product, name: nil)
        expect(modifier_group).not_to be_valid
        expect(modifier_group.errors.full_messages).to include("Nome não pode ficar em branco")
      end

      it 'is invalid without input_type' do
        modifier_group = ModifierGroup.new(product: product, input_type: nil)
        expect(modifier_group).not_to be_valid
        expect(modifier_group.errors.full_messages).to include("Tipo de Escolha não pode ficar em branco")
      end
    end

    context 'comparison validations' do
      it 'is invalid if min is negative' do
        modifier_group = ModifierGroup.new(product: product, min: -1, max: 1, free_limit: 1)
        expect(modifier_group).not_to be_valid
        expect(modifier_group.errors.full_messages).to include("Mínimo deve ser maior ou igual a 0")
      end

      it 'is invalid if max is less than min' do
        modifier_group = ModifierGroup.new(product: product, min: 2, max: 1, free_limit: 1)
        expect(modifier_group).not_to be_valid
        expect(modifier_group.errors.full_messages).to include("Máximo deve ser maior ou igual a Mínimo")
      end

      it 'is invalid if max is less than free_limit' do
        modifier_group = ModifierGroup.new(product: product, min: 1, max: 1, free_limit: 2)
        expect(modifier_group).not_to be_valid
        expect(modifier_group.errors.full_messages).to include("Máximo deve ser maior ou igual a Limite Grátis")
      end
    end

    context '#validate_type_specific_limits' do
      context 'single_choice rules' do
        it 'requires min, max = 1 and free_limit = max' do
          modifier_group = ModifierGroup.new(
            product: product,
            input_type: :single_choice,
            min: 2,
            max: 3,
            free_limit: 2
          )

          expect(modifier_group).not_to be_valid
          expect(modifier_group.errors.full_messages).to include(
            "Mínimo em Única Escolha deve ser sempre 1",
            "Máximo em Única Escolha deve ser sempre 1",
            "Limite Grátis deve ser igual ao valor de Máximo"
          )
        end
      end

      context 'multiple_choice rules' do
        it 'requires max >= 2' do
          modifier_group = ModifierGroup.new(
            product: product,
            input_type: :multiple_choice,
            min: 1,
            max: 1,
            free_limit: 1
          )

          expect(modifier_group).not_to be_valid
          expect(modifier_group.errors.full_messages).to include(
            "Máximo deve ser no mínimo 2, em Múltipla Escolha"
          )
        end

        it 'requires free_limit = max' do
          modifier_group = ModifierGroup.new(
            product: product,
            input_type: :multiple_choice,
            min: 1,
            max: 3,
            free_limit: 1
          )

          expect(modifier_group).not_to be_valid
          expect(modifier_group.errors.full_messages).to include(
            "Limite Grátis deve ser igual ao valor de Máximo"
          )
        end
      end

      context 'quantity rules' do
        it 'allows flexible min, max, and free_limit' do
          modifier_group = ModifierGroup.new(
            name: 'Escolha uma bebida',
            product: product,
            input_type: :quantity,
            min: 2,
            max: 5,
            free_limit: 3
          )

          expect(modifier_group).to be_valid
        end

        it 'is invalid if max < min' do
          modifier_group = ModifierGroup.new(product: product, input_type: :quantity, min: 3, max: 2, free_limit: 1)
          expect(modifier_group).not_to be_valid
          expect(modifier_group.errors.full_messages).to include("Máximo deve ser maior ou igual a Mínimo")
        end

        it 'is invalid if max < free_limit' do
          modifier_group = ModifierGroup.new(product: product, input_type: :quantity, min: 1, max: 1, free_limit: 2)
          expect(modifier_group).not_to be_valid
          expect(modifier_group.errors.full_messages).to include("Máximo deve ser maior ou igual a Limite Grátis")
        end
      end
    end
  end
end
