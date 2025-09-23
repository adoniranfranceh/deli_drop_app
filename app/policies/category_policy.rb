class CategoryPolicy < ApplicationPolicy
  def update?
    user.present? && record.restaurant.restaurant_user_id == user.id
  end
end
