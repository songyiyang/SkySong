Skysong::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" }
  get '/disconnect', to: 'pages#disconnect'
  get '/connect', to: 'pages#connect'
  root 'info#main'
  get '/main', to:'pages#main_page', as: 'main_path'
  get '/chat', to: 'messages#index'
  get '/check_connect', to: 'pages#check_connect'
  get '/clear_session', to: 'pages#clear_session'
  get '/publish', to: 'pages#publish'
  get '/clear', to: 'pages#clear'
  get '/xkcd', to: 'pages#xkcd'
  get '/color_diff', to: 'pages#color'
  post '/send_img', to: 'pages#send_img'
  get '/info', to:'info#main'
  get '/chat_together', to: 'pages#together'
  get '/publish_together', to: 'pages#publish_together'
  get '/connect_together', to: 'pages#connect_together'
  resources :messages
end
