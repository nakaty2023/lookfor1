Rails.application.routes.draw do
  root 'users#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :shops, only: %i[new create show]
  resources :users, only: %i[show index]
end
