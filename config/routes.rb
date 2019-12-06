Rails.application.routes.draw do
  devise_for :users, 
  controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'items#index'

  resources :items, only: [:index, :new, :create] do
    member do
      get :buy
      post :pay
    end
  end

  resources :users, only: [:index, :edit] do
    collection do
      get :logout
      get :profile
    end
  end

  resources :signups, only: [:index, :create] do
    collection do
      get :first, :second, :third, :forth, :fifth, :done
    end
  end

  resources :cards, only: [:create, :show, :new] do
    collection do
      post 'delete', to: 'cards#delete'
      post 'show'
    end
    member do
      get 'confirmation'
    end
  end 
  
end
