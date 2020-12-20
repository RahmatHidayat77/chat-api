Rails.application.routes.draw do

  namespace :api, defaults: { format: 'json' }  do
    # your api json routes...

    resources :users
    post 'signup', to: 'user#create'
    post 'login', to: 'authentication#authenticate'

  end
  
  
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
