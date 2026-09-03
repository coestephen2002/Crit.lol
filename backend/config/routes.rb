require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: 'refactory_session'
  mount Sidekiq::Web => '/sidekiq'

  scope '/api', defaults: { format: :json } do
    resources :accounts, only: [:create, :show] do
      collection do
        post 'login'
        post 'logout'
      end
    end
    resources :summoners do
      collection do
        post 'search'
        get 'show'
      end
      member do
        get 'champion_masteries', to: 'champion_masteries#show'
      end
      resources :ranks, only: [:index]
      resources :matches, only: [:index]
    end
    resources :champions, only: [:index] do
      collection do
        post 'search'
        get 'show'
      end
    end
  end
end
