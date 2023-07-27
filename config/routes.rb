Rails.application.routes.draw do
  root 'application#test'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: [:show]
end
