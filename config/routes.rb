Rails.application.routes.draw do
  devise_for :restaurant_users
  # get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"

  get "/menu", to: "menus#show"
  get "/products/new", to: "products#new"

  resources :restaurants, only: %i[new edit]

  namespace :api do
    namespace :v1 do
      resources :restaurants, only: %i[create update]
      resources :categories, only: %i[index create]
      resources :products, only: %i[create]
    end
  end

  get "/flash", to: "flash#redirect"
end
