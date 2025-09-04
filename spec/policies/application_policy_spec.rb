require "rails_helper"

RSpec.describe ApplicationPolicy do
  let(:user) { double("user") }
  let(:record) { double("record") }
  let(:policy) { described_class.new(user, record) }

  describe "default actions" do
    it "index? returns false" do
      expect(policy.index?).to be false
    end

    it "show? returns false" do
      expect(policy.show?).to be false
    end

    it "create? returns false" do
      expect(policy.create?).to be false
    end

    it "new? delegates to create?" do
      expect(policy.new?).to eq(policy.create?)
    end

    it "update? returns false" do
      expect(policy.update?).to be false
    end

    it "edit? delegates to update?" do
      expect(policy.edit?).to eq(policy.update?)
    end

    it "destroy? returns false" do
      expect(policy.destroy?).to be false
    end
  end

  describe "Scope" do
    let(:scope) { double("scope") }
    let(:scope_instance) { described_class::Scope.new(user, scope) }

    it "raises error if resolve not implemented" do
      expect { scope_instance.resolve }.to raise_error(NoMethodError, /You must define #resolve/)
    end
  end
end
