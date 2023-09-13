Rails.application.routes.draw do
  resources :users, only: %i[new create]
  root to: 'tops#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
