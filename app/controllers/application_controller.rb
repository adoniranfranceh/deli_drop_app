class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_restaurant_user!
  before_action :restaurant_user_signed_in?

  private

  def restaurant_user_signed_in?
    if current_restaurant_user && current_restaurant_user.restaurant.nil?
      unless flash[:alert].present? || flash[:notice].present?
        redirect_to new_restaurant_path, alert: I18n.t("alerts.restaurant.must_register")
      end
    end
  end
end
