Rails.application.routes.draw do
  devise_for :restaurant_users
  # get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
  get "/menu", to: "menus#show"
  get "/orders", to: "orders#index"

  resources :restaurants, only: %i[new edit]
  resources :products, only: %i[new edit]

  namespace :api do
    namespace :v1 do
      resources :restaurants, only: %i[create update show index]
      resources :categories, only: %i[index create update]
      resources :products, only: %i[create update index]

      resources :orders, only: [:index, :create], param: :code do
        member do
          get "/", action: :show
          patch :cancel
        end
      end

      namespace :restaurant do
        resources :orders, only: %i[index show] do
          member do
            patch :accept
            patch :reject
            patch :status
          end
        end
      end
    end
  end

  get "/flash", to: "flash#redirect"
end
