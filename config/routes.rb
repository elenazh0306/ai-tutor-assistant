Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  
  resources :subjects do
    resources :materials
    resources :tests, except: [:edit, :update]
    resources :chats, only: [:create, :index]

  end

  resources :tests, only: [:destroy] do
    resources :feedbacks, only: [:create, :show]
  end

  resources :chats, except: [:create, :index] do
    resources :messages, only: [:create]
  end

  get "up" => "rails/health#show", as: :rails_health_check

end
