Rails.application.routes.draw do

  namespace :api, defaults: { format: 'json' }  do
    # your api json routes...

    resources :users
    post 'signup', to: 'user#create'
    post 'login', to: 'authentication#authenticate'

    post 'send-message', to: 'chat#send_message'
    put 'update-message', to: 'chat#update_message'
    post 'delete-message', to: 'chat#delete_message'
    get 'list-message', to: 'chat#list_message'
    get 'list-all-conversation', to: 'chat#list_all_conversation'

  end
  
  
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
