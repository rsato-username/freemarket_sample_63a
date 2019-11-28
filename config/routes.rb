Rails.application.routes.draw do
  devise_for :users, 
  controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'items#index'

  resources :items, only: [:index, :new, :create]
  resources :users, only: [:index]
  resources :signups, only: [:index, :new, :create] do
    collection do
      get :first, :second, :third, :forth, :fifth
    end
  end
end
