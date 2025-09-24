class FlashController < ApplicationController
  skip_before_action :restaurant_registered?

  def redirect
    flash[:notice] = params[:notice] if params[:notice].present?
    flash[:alert]  = params[:alert] if params[:alert].present?
    redirect_to params[:path] || root_path
  end
end
