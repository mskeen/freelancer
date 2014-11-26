Rails.application.routes.draw do
  devise_for :users

  resources :event_trackers

  unauthenticated do
    root 'brochure#index'
  end

  authenticated :user do
    root to: 'dashboard#index', as: 'authenticated_root'
  end

end
