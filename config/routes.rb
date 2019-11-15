Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :lessons, only: [:create, :show, :index]

      post 'send_new_user_email', to: 'users#send_new_user_email'

      post 'set_password', to: 'users#set_password'

      post 'initiate_password_reset', to: 'users#send_password_reset_email'

      post 'presigned_upload_url', to: 'assets#presigned_upload_url'

      namespace :admin do
        get 'dashboard', to: 'dashboard#show'
      end

      namespace :teacher do
        get 'dashboard', to: 'dashboard#show'
      end

      namespace :student do
        get 'dashboard', to: 'dashboard#show'
      end
    end
  end
end
