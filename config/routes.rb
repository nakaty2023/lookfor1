Rails.application.routes.draw do
  root 'shops#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :shops, only: %i[new create show destroy index]
  resources :users, only: %i[show index] do
    member do
      get :profile
    end
  end
  resources :shopposts, only: %i[create destroy]
end
