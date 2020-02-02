Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :lessons, only: [:create, :show, :index]
      resources :assignments, only: [:create, :index]

      get '/students', to: 'users#index'

      post 'send-new-user-email', to: 'users#send_new_user_email'

      post 'set-password', to: 'users#set_password'

      post 'initiate-password-reset', to: 'users#send_password_reset_email'

      post 'reset-password', to: 'users#reset_password'

      post 'presigned-upload-url', to: 'assets#presigned_upload_url'

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
