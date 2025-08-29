Rails.application.routes.draw do
  devise_for :restaurant_users
  # get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"

  get "/menu", to: "menus#show"
  get "/products/new", to: "products#new"

  resources :restaurants, only: %i[new edit]

  namespace :api do
    namespace :v1 do
      resources :restaurants, only: %i[create update ]
    end
  end
end
