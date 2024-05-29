Rails.application.routes.draw do
  root 'nodes#index'


  resources :nodes
  get :test_connection, to: 'nodes#test_connection'
  get :test , to: 'nodes#test_connection'
end
