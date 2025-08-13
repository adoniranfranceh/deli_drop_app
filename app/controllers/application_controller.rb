class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_restaurant_user!
end
