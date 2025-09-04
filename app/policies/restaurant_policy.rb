class RestaurantPolicy < ApplicationPolicy
  def new?
    user.present? && user.restaurant.blank?
  end

  def edit?
    user.present? && record.restaurant_user_id == user.id
  end
end
