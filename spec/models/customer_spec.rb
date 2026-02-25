require 'rails_helper'

RSpec.describe Customer, type: :model do
  context '.validations' do
    it 'is invalid without a name' do
      customer = Customer.new(name: nil, phone: "89 99999-0001")
      expect(customer).not_to be_valid
      expect(customer.errors.full_messages).to include("Nome não pode ficar em branco")
    end

    it 'is invalid without a phone' do
      customer = Customer.new(name: "João", phone: nil)
      expect(customer).not_to be_valid
      expect(customer.errors.full_messages).to include("Telefone não pode ficar em branco")
    end

    it 'enforces uniqueness of phone' do
      create(:customer, phone: "89 99999-1111")
      duplicate = Customer.new(name: "Maria", phone: "89 99999-1111")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors.full_messages).to include("Telefone já está em uso")
    end

    it 'enforces uniqueness of email when present' do
      create(:customer, email: "joao@email.com")
      duplicate = Customer.new(name: "Maria", phone: "89 99999-2222", email: "joao@email.com")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors.full_messages).to include("Email já está em uso")
    end

    it 'allows blank email' do
      customer = Customer.new(name: "João", phone: "89 99999-3333", email: "")
      expect(customer).to be_valid
    end

    it 'is valid with name and phone' do
      customer = Customer.new(name: "João Silva", phone: "89 99999-4444")
      expect(customer).to be_valid
    end
  end
end
