Rails.application.routes.draw do
  # get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"

  get "/menu", to: "menus#show"
end
