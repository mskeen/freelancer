Rails.application.routes.draw do

  devise_for :users, skip: [:registrations]
  devise_scope :user do
    scope '/account' do
      get '/join', to: 'devise/registrations#new', as: 'new_user_registration'
      post '/join', to: 'devise/registrations#create', as: 'user_registration'
    end
  end

  get 'ping/:id', to: 'event_trackers#ping', as: :ping_event_tracker

  resources :event_trackers
  resources :contacts, except: [:index, :show]
  resource :account, only: [:edit, :update]

  unauthenticated do
    root 'brochure#index'
  end

  authenticated :user do
    root to: 'dashboard#index', as: 'authenticated_root'
  end
end
