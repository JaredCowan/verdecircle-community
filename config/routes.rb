# Route prefixes use a single letter to allow for vanity urls of two or more characters
Rails.application.routes.draw do
  if defined? Sidekiq
    require 'sidekiq/web'
    authenticate :user, lambda {|u| u.is_admin? } do
      mount Sidekiq::Web, at: '/admin/sidekiq/jobs', as: :sidekiq
    end
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if defined? RailsAdmin

  # Static pages
  match '/error' => 'pages#error', via: [:get, :post], as: 'error_page'
  get '/terms' => 'pages#terms', as: 'terms'
  get '/privacy' => 'pages#privacy', as: 'privacy'
  get '/users', to: 'users#index', as: 'users_page'
  get '/u/:username', to: 'users#profile', as: 'profile_page'

  # OAuth
  oauth_prefix = Rails.application.config.auth.omniauth.path_prefix
  get "#{oauth_prefix}/:provider/callback" => 'users/oauth#create'
  get "#{oauth_prefix}/failure" => 'users/oauth#failure'
  get "#{oauth_prefix}/:provider" => 'users/oauth#passthru', as: 'provider_auth'
  get oauth_prefix => redirect("#{oauth_prefix}/login")

  # Devise
  devise_prefix = Rails.application.config.auth.devise.path_prefix
  devise_for :users, path: devise_prefix,
    controllers: {registrations: 'users/registrations', sessions: 'users/sessions',
      passwords: 'users/passwords', confirmations: 'users/confirmations', unlocks: 'users/unlocks'},
    path_names: {sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  devise_scope :user do
    get "#{devise_prefix}/after" => 'users/registrations#after_auth', as: 'user_root'
  end
  get devise_prefix => redirect('/a/signup')

  # User
  resources :users, path: 'u', only: :show do
    resources :authentications, path: 'accounts'
  end

  resources :conversations, path: '/messages' do
    member do
      post :reply
      post :trash
      post :untrash
      post :perm_trash
    end
  end

  get '/emptytrash', to: 'conversations#empty_trash', as: 'empty_trash'

  get '/home' => 'users#show', as: 'user_home'

  # Dummy preview pages for testing.
  get '/p/test' => 'pages#test', as: 'test'
  get '/p/email' => 'pages#email' if ENV['ALLOW_EMAIL_PREVIEW'].present?

  get 'robots.:format' => 'robots#index'

  root 'pages#home'
end
