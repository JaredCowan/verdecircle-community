# Route prefixes use a single letter to allow for vanity urls of two or more characters
Rails.application.routes.draw do

  if defined? Sidekiq
    require 'sidekiq/web'
    authenticate :user, lambda {|u| u.is_admin? } do
      mount Sidekiq::Web, at: '/admin/sidekiq/jobs', as: :sidekiq
    end
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if defined? RailsAdmin

  scope '/posts' do
    get '/tags/:tag', to: 'posts#index', as: :tag
  end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  # Posts, Posts likes, Post Comments & Post Comment likes
  resources :posts, concerns: :paginatable do
    member do
      put "like", to: "posts#liked"
      put "unlike", to: "posts#unliked"
      put "dislike", to: "posts#disliked"
      put "undislike", to: "posts#undisliked"
      put "favorite", to: "favorites#add_favorite", defaults: { className: 'Post' }
      delete "unfavorite", to: "favorites#remove_favorite", defaults: { className: 'Post' }
    end

    resources :comments, except: [:show, :edit] do
      member do
        put "like", to: "comments#liked"
        put "unlike", to: "comments#unliked"
        put "dislike", to: "comments#disliked"
        put "undislike", to: "comments#undisliked"
      end

      resources :replies, except: [:show, :edit] do
        member do
          put "like", to: "replies#liked"
          put "unlike", to: "replies#unliked"
          put "dislike", to: "replies#disliked"
          put "undislike", to: "replies#undisliked"
        end
      end
    end
  end

  resources :topics, path: '/categories/posts'

  resources :contacts, path: '/contact'
  match '/contacts/submits', to: "contacts#submits", via: :get, as: :contact_submits

  resources :blogs, path: '/blog'

  resources :activities, only: [:index, :destroy], concerns: :paginatable

  # Route for undoing / redoing changes made to a post
  post "versions/:id/revert", to: "versions#revert", as: "revert_version"

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

  resources :user_relationships, path: '/u/:username/followers', concerns: :paginatable do
    member do
      post :new, to: "user_relationships#create"
    end
  end
  
  scope '/u/:username' do
    get 'profile', to: "users#profile"
    match '/followers', to: "user_relationships#index", defaults: { path: 'followers' }, via: :get
    match '/followers', to: "user_relationships#index", defaults: { path: 'followers' }, via: :get
    resources :favorites, only: [:index], concerns: :paginatable

    resources :notifications, only: [:index], concerns: :paginatable do
      collection do
        post 'markasread', to: 'notifications#mark_as_read', as: :mark_all_read
        post 'markasunread', to: 'notifications#mark_as_unread', as: :mark_all_unread
      end
      member do
        post 'markasread', to: 'notifications#mark_as_read', as: :mark_as_read
        post 'optout', to: 'notifications#opt_out', as: :opt_out
      end
    end
  end

  # get '/:username', to: redirect('/u/%{username}')

  get '/emptytrash', to: 'conversations#empty_trash', as: 'empty_trash'

  get '/home', to: 'users#show', as: 'user_home'

  get '/index', to: 'pages#index'
  get '/pricing', to: 'pages#pricing'

  # Dummy preview pages for testing.
  get '/p/test' => 'pages#test', as: 'test'
  get '/p/email' => 'pages#email' if ENV['ALLOW_EMAIL_PREVIEW'].present?

  get 'robots.:format' => 'robots#index'

  root 'pages#home'

  scope '/dashboard' do
    get '/', to: redirect("/dashboard/posts")
    scope '/:view' do
      get '/', to: "users#dashboard", defaults: { view: 'posts' }, as: :user_dashboard
    end
  end

  # ToDo: Decide which route(no pun intended) I want to take to handle routing errors
  # 
  # Handle routing errors
  ## NEVER PUT ROUTES BELOW THIS LINE
  # get "*path", to: 'application#routing_error', via: 'get'
  # get "*path", to: redirect("/")
end
