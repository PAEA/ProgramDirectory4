Rails.application.routes.draw do

  root "programs#index"

  get "/index" => "programs#index"
  get "/information" => "programs#information"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
