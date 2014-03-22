Skysong::Application.routes.draw do
  devise_for :users
  root to: 'pages#main_page'
end
