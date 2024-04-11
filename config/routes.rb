Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider

  get 'terms_of_use', to: 'static_pages#terms_of_use'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  root to: 'tops#index'
  get 'tops/search', to: 'tops#search'

  resources :beans, only: %i[index show new create] do
    get :search, on: :collection
    resource :favorite, only: %i[create destroy]
  end

  resources :purchases, only: %i[new create edit update] do
    resources :reviews, only: %i[new create edit update], shallow: true do
      get :image, on: :member
      resource :like, only: %i[create destroy]
    end
  end

  resources :shops, only: %i[index new create] do
    get :search, on: :collection
  end

  namespace :mypage do
    root to: redirect('mypage/purchases')
    resources :purchases, only: %i[index destroy]
    resources :reviews, only: %i[index destroy]
    resource :profile, only: %i[show edit update]
  end

  resources :password_resets, only: %i[new create edit update]
  resources :user_profiles, only: %i[show]

  namespace :admin do
    root to: 'dashboards#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :users, only: %i[index edit update destroy]
    resources :beans, only: %i[index new create edit update destroy]
    resources :shops, only: %i[index new create edit update destroy]
    resources :purchases, only: %i[index edit update destroy]
    resources :reviews, only: %i[index edit update destroy]
    resources :regions
    resources :tools
    resources :brewing_methods
    resources :top_sliders, only: %i[index new create edit update destroy]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
