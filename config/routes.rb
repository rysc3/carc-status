Rails.application.routes.draw do
  root 'nodes#index'

  resources :nodes
end
