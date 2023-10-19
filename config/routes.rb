Rails.application.routes.draw do
  root 'homes#home'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  resources :shops, only: %i[new create show destroy index] do
    collection do
      get :search
    end
  end
  resources :users, only: %i[show index] do
    member do
      get :profile
      get :exchangeposts
      get :comments
    end
  end
  resources :shopposts, only: %i[create destroy]
  resources :exchangeposts, only: %i[new create index destroy show] do
    collection do
      get :search
    end
  end
  resources :comments, only: %i[create destroy]
  resources :messages, only: :destroy
  resources :conversations, only: %i[index create show] do
    resources :messages, only: %i[create]
  end
end
