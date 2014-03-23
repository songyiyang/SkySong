Skysong::Application.routes.draw do
  devise_for :users
  get '/disconnect', to: 'pages#disconnect'
  get '/connect', to: 'pages#connect'
  root 'pages#main_page'
  get '/chat', to: 'messages#index'
  get '/check_connect', to: 'pages#check_connect'
  get '/clear_session', to: 'pages#clear_session'
  resources :messages
end
