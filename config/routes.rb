Rails.application.routes.draw do
  root to: "developers#index"
  devise_for :users
  resources :developers do
    resources :bookings, only: [:new, :create]
    resources :reviews, only: [:new, :create]
  end
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  get 'profile/:id', to: 'pages#profile', as: 'user_profile'
  patch 'bookings/:id/accept', to: 'bookings#accept', as: 'accept_booking'
  patch 'bookings/:id/refuse', to: 'bookings#refuse', as: 'refuse_booking'
end
