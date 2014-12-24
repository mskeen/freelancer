Rails.application.routes.draw do

  devise_for :users, skip: [:registrations]
  devise_scope :user do
    scope '/account' do
      get '/join', to: 'devise/registrations#new', as: 'new_user_registration'
      post '/join', to: 'devise/registrations#create', as: 'user_registration'
    end
  end

  get 'ping/:id', to: 'event_trackers#ping', as: :ping_event_tracker

  resources :users
  resources :event_trackers
  resources :tasks, only: [:index, :create, :edit, :update, :destroy] do
    match 'new/:task_category_id', to: 'tasks#new', via: :get, as: "new", on: :collection
    resources :completions, controller: 'task_completions', only: [:new] do
      match '', to: 'task_completions#destroy', via: :delete, as: "destroy", on: :collection
    end
  end
  resources :task_categories, only: [:show, :new, :create, :edit, :update, :destroy ]
  resources :contacts, except: [:index, :show]
  resources :api_keys, only: [:create, :destroy, :edit, :update]
  resource :account, only: [:edit, :update] do
    patch 'update_password', on: :member
  end

  # API
  namespace :api do
    namespace :v1 do
      get '/organization', to: 'organization#show'
      put '/organization', to: 'organization#update'
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end

  unauthenticated do
    root 'brochure#index'
  end

  authenticated :user do
    root to: 'dashboard#index', as: 'authenticated_root'
  end
end
