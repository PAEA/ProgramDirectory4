Rails.application.routes.draw do

  get "/index" => "schools#index"
  get "/information" => "schools#information"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
