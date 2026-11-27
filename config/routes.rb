Rails.application.routes.draw do
  root "home#index"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"
 feature/simple-login

  resources :point_transactions, only: [:index, :new, :create]
=======
  resources :spots, only: [:index, :show]
  resources :photo_posts, only: [:index, :new, :create]
 main
end