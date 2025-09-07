class ModifierGroup < ApplicationRecord
  belongs_to :product
  has_many :modifiers, dependent: :destroy

  accepts_nested_attributes_for :modifiers, allow_destroy: true

  enum :input_type, { single_choice: 5, multiple_choice: 10, quantity: 15 }

  validates :name, :input_type, :min, :max, :free_limit, presence: true
  validates :min, comparison: { greater_than_or_equal_to: 0 }
  validates :max, comparison: { greater_than_or_equal_to: 0 }
  validates :free_limit, comparison: { greater_than_or_equal_to: 0 }

  validate :max_vs_min_and_free_limit
  validate :type_specific_limits

  private

  def max_vs_min_and_free_limit
    if max.present? && min.present? && max < min
      errors.add(:max, "deve ser maior ou igual a #{self.class.human_attribute_name(:min)}")
    end

    if max.present? && free_limit.present? && max < free_limit
      errors.add(:max, "deve ser maior ou igual a #{self.class.human_attribute_name(:free_limit)}")
    end
  end

  def type_specific_limits
    case input_type
    when "single_choice"   then validate_single_choice
    when "multiple_choice" then validate_multiple_choice
    end
  end

  def validate_single_choice
    errors.add(:min, I18n.t("modifier_group.single_choice.min")) unless min == 1
    errors.add(:max, I18n.t("modifier_group.single_choice.max")) unless max == 1
    errors.add(:free_limit, I18n.t("modifier_group.single_choice.free_limit")) unless free_limit == max
  end

  def validate_multiple_choice
    errors.add(:max, I18n.t("modifier_group.multiple_choice.max")) if max < 2
    errors.add(:free_limit, I18n.t("modifier_group.multiple_choice.free_limit")) unless free_limit == max
  end
end
