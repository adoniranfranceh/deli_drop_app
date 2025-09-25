Rails.application.routes.draw do
  devise_for :restaurant_users
  # get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
  get "/menu", to: "menus#show"

  resources :restaurants, only: %i[new edit]
  resources :products, only: %i[new edit]

  namespace :api do
    namespace :v1 do
      resources :restaurants, only: %i[create update]
      resources :categories, only: %i[index create update]
      resources :products, only: %i[create update]
    end
  end

  get "/flash", to: "flash#redirect"
end
