class Api::V1::ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_restaurant_user
  end

  private

  def user_not_authorized
    render json: { errors: I18n.t("alerts.pundit.default") }, status: :unauthorized
  end
end
