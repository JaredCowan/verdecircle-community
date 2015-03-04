# Route prefixes use a single letter to allow for vanity urls of two or more characters
Rails.application.routes.draw do

  if defined? Sidekiq
    require 'sidekiq/web'
    authenticate :user, lambda {|u| u.is_admin? } do
      mount Sidekiq::Web, at: '/admin/sidekiq/jobs', as: :sidekiq
    end
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if defined? RailsAdmin

  get 'posts/tags/:tag', to: 'posts#index', as: :tag

  # Posts, Posts likes, Post Comments & Post Comment likes
  resources :posts do
    member do
      put "like", to: "posts#liked"
      put "unlike", to: "posts#unliked"
      put "dislike", to: "posts#disliked"
      put "undislike", to: "posts#undisliked"
    end

    resources :comments, except: [:show, :edit] do
      member do
        put "like", to: "comments#liked"
        put "unlike", to: "comments#unliked"
        put "dislike", to: "comments#disliked"
        put "undislike", to: "comments#undisliked"
      end
    end
  end

  resources :topics, path: '/topics/posts/'

  resources :activities, only: [:index, :destroy]
  
  # Route for undoing / redoing changes made to a post
  post "versions/:id/revert" => "versions#revert", :as => "revert_version"

  # Route for restoring a soft deleted post or permanently deleting it
  post "versions/:id/restore_post" => "versions#restore_post", :as => "restore_post"
  delete "versions/:id/super_delete_post" => "versions#super_delete_post", :as => "super_delete_post"

  # Route for restoring a soft deleted comment or permanently deleting it
  post "versions/:id/restore_comment" => "versions#restore_comment", :as => "restore_comment"
  delete "versions/:id/super_delete_comment" => "versions#super_delete_comment", :as => "super_delete_comment"

  # Restore all comments and post
  post "versions/restore_all_post" => "versions#restore_all_post", :as => "restore_all_post"
  post "versions/restore_all_comment" => "versions#restore_all_comment", :as => "restore_all_comment"

  # Static pages
  match '/error', to: 'pages#error', via: [:get, :post], as: 'error_page'
  get '/terms', to: 'pages#terms', as: 'terms'
  get '/privacy', to: 'pages#privacy', as: 'privacy'
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

  # get '/home' => 'users#show', as: 'user_home'
  get '/home' => 'users#profile', as: 'user_home'

  # Dummy preview pages for testing.
  get '/p/test' => 'pages#test', as: 'test'
  get '/p/email' => 'pages#email' if ENV['ALLOW_EMAIL_PREVIEW'].present?

  get 'robots.:format' => 'robots#index'

  root 'pages#home'

  # Handle routing errors
  ## NEVER PUT ROUTES BELOW THIS LINE
  # match "*path", to: 'application#routing_error', via: 'get'
end
