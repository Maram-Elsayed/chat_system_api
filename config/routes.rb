require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    scope module: :v1, path: "(/:version)", constraints: { version: /v1(.\d)?/ } do
      resources :applications, param: :token do
        resources :chats, param: :number do
          resources :messages, param: :number
        end
      end
    end
  end
end
