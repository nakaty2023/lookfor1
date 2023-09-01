Rails.application.routes.draw do
  root 'shops#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :shops, only: %i[new create show destroy index]
  resources :users, only: %i[show index]
  resources :shopposts, only: %i[create destroy]
end
