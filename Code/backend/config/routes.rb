Rails.application.routes.draw do
  resources :ticket_responses
  resources :tickets
  post 'login'  => 'authentication#authenticate_user'
  get 'ping'    => 'authentication#ping'

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
