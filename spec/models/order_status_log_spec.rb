require 'rails_helper'

RSpec.describe OrderStatusLog, type: :model do
  let(:order) { create(:order) }

  context '.validations' do
    it 'is invalid without a to_status' do
      log = OrderStatusLog.new(order: order, to_status: nil, changed_by: "restaurant")
      expect(log).not_to be_valid
      expect(log.errors.full_messages).to include("Status Destino não pode ficar em branco")
    end

    it 'is invalid without a changed_by' do
      log = OrderStatusLog.new(order: order, to_status: 5, changed_by: nil)
      expect(log).not_to be_valid
      expect(log.errors.full_messages).to include("Alterado Por não pode ficar em branco")
    end

    it 'is valid with all required attributes' do
      log = OrderStatusLog.new(order: order, from_status: 0, to_status: 5, changed_by: "restaurant")
      expect(log).to be_valid
    end

    it 'allows nil from_status for initial log' do
      log = OrderStatusLog.new(order: order, from_status: nil, to_status: 0, changed_by: "system")
      expect(log).to be_valid
    end
  end
end
