Rails.application.routes.draw do

  get "/*", to: 'user_sessions#maintenance'

  root "user_sessions#new"

  get "/index" => "programs#index"
  get "/information/:id" => "programs#information"
  get "/information/:id/:edit" => "programs#information_edit"
  get "/search" => "programs#search"
  post "/authenticate" => "user_sessions#authenticate"
<<<<<<< HEAD
  get "/terms-and-conditions" => "user_sessions#terms_and_conditions_pdf"
=======
  get "settings" => "settings#index"
  post "/save_settings" => "settings#save_settings"
  get "/terms-and-conditions" => "user_sessions#terms_and_conditions_pdf"
  post "/save_changes/:id" => "programs#save_changes"
  get "/approve_change/:program_id/:field_id/:field_type" => "programs#approve_change"
  get "/reject_change/:program_id/:field_id/:field_type" => "programs#reject_change"
  post "/role_x_fields/:role_id" => "settings#role_x_fields"
>>>>>>> settings

  #resources :users, only: [:new, :create]
  resources :user_sessions, only: [:new, :authenticate, :destroy]

  #resources :programs do
  #  get :approve_change, on: :member
  #end

  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
