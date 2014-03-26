Skysong::Application.routes.draw do
  devise_for :users
  get '/disconnect', to: 'pages#disconnect'
  get '/connect', to: 'pages#connect'
  root 'pages#main_page'
  get '/chat', to: 'messages#index'
  get '/check_connect', to: 'pages#check_connect'
  get '/clear_session', to: 'pages#clear_session'
  get '/publish', to: 'pages#publish'
  get '/clear', to: 'pages#clear'
  get '/xkcd', to: 'pages#xkcd'
  get '/color_diff', to: 'pages#color'
  resources :messages
end
