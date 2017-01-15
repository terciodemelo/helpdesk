Rails.application.routes.draw do
  resources :tickets do
    resources :ticket_responses, except: [:update]
  end
  post 'login'  => 'authentication#authenticate_user'
  get 'ping'    => 'authentication#ping'

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
