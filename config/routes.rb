Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json },
                     controllers: { sessions: 'users/sessions' },
                     path: '',
                     path_names: { sign_in: 'sign-in' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :products

  get 'users/:id/orders', to: 'orders#index'
  get 'users/:id/orders/:order_date/products', to: 'orders#show'
  get 'users/:id/shopping_cart', to: 'orders#show', defaults: { order_date: nil }
  post 'users/:id/shopping_cart', to: 'orders#create'
  delete 'users/:id/shopping_cart/:product_id', to: 'orders#destroy'
  post 'users/:id/shopping_cart/process', to: 'orders#process_cart'
end
