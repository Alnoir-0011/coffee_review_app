Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  root to: 'tops#index'

  resources :beans, only: %i[index show new create]
  resources :shops, only: %i[index new create]
  namespace :mypage do
    root to: redirect('mypage/purchases')
    resources :purchases, only: %i[index new create edit update destroy]
    resources :reviews, only: %i[index new create edit update destroy]
    resource :profile, only: %i[show edit update]
  end

  resources :password_resets, only: %i[new create edit update]

  resources :user_profiles, only: %i[show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
