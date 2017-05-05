Rails.application.routes.draw do

  root "user_sessions#new"

  get "/index" => "programs#index"
  get "/information/:id" => "programs#information"
  post "/search" => "programs#search"

  resources :users, only: [:new, :create]
  resources :user_sessions, only: [:create, :destroy]

  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
