Rails.application.routes.draw do
  devise_for :users

  get 'ping/:id', to: 'event_trackers#ping', as: :ping_event_tracker
  resources :event_trackers do
    get 'ping', on: :member
  end

  unauthenticated do
    root 'brochure#index'
  end

  authenticated :user do
    root to: 'dashboard#index', as: 'authenticated_root'
  end

end
