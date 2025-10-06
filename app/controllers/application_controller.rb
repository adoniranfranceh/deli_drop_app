class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_restaurant_user!
  before_action :restaurant_registered?

  include Pundit::Authorization

  def pundit_user
    current_restaurant_user
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = I18n.t "alerts.pundit.default", default:
    redirect_to(request.referer || root_path)
  end

  def restaurant_registered?
    if current_restaurant_user && current_restaurant_user.restaurant.nil?
      unless flash[:alert].present? || flash[:notice].present?
        redirect_to new_restaurant_path, alert: I18n.t("alerts.restaurant.must_register")
      end
    end
  end
end
