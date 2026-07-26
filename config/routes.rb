Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "subjects#index", as: :authenticated_root
  end

  unauthenticated do
    devise_scope :user do
      root to: "pages#home", as: :unauthenticated_root
    end
  end


  
  resources :subjects do
    resources :materials
    resources :tests, except: [:edit, :update]
    resources :chats, only: [:create, :index]

  end

  resources :tests, only: [:new, :create] do
    resources :questions, only: [:new, :create]
    resources :feedbacks, only: [:create, :show]
  end



  resources :chats, except: [:create, :index] do
    resources :messages, only: [:create]
  end

  get "up" => "rails/health#show", as: :rails_health_check

end
