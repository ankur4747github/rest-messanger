Rails.application.routes.draw do
  post '/signup' => 'auths#signup'
  post '/login' => 'auths#login'
  get '/messages' => 'user_messages#index'
  post '/messages/new' => 'user_messages#new'
  post '/messages/edit' => 'user_messages#edit'

  mount ActionCable.server => '/cable'
end
