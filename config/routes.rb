Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :users, only: [:create]

      namespace :admin do
        get 'dashboard', to: 'dashboard#show'
      end

      namespace :student do
        get 'dashboard', to: 'dashboard#show'
      end
    end
  end
end
