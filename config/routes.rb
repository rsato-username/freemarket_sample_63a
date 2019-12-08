Rails.application.routes.draw do
  devise_for :users, 
  controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'items#index'

  resources :items do
    collection do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
      get :search
    end
    member do
      get :buy
      get :purchash
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
