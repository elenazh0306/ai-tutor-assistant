Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :subjects do
    resources :materials
    resources :tests, except: [:edit, :update]

  end

  resources :tests, only: [:destroy] do
    resources :feedbacks, only: [:create, :show]
  end

  resources :chat do
    resources :messages, only: [:create]
  end

  get "up" => "rails/health#show", as: :rails_health_check


end
