Rails.application.routes.draw do
  resources :likes, only: [:create, :destroy]
  resources :commentaries, only: [:destroy, :create, :edit, :update]
  resources :follow, only: [ :create, :destroy ]
  resources :posts, only: [ :create, :show, :update, :destroy, :new, :edit ]

  devise_for :users

  root "application#index"
  get "/profile/:id", to: "velocyclegram#profile", as: 'profile'

  get "/followers/:id", to: "follow#followers", as: 'followers'
  get "/followings/:id", to: "follow#followings", as: 'followings'

  get "/user/:page", to: "users#show", as: 'users'
  get "/user/:id/edit", to: "users#edit", as: 'edit_user'
  patch "/user/:id", to: "users#update"
  put "/user/:id", to: "users#update"
  delete "/user/:id", to: "users#destroy", as: 'user'

  get "/commentary/:post_id", to: "commentaries#new", as: "new_comment"

  post "/busket", to: "user_busket#create", as: "add_to_busket"
  delete "/busket", to: "user_busket#destroy", as: "destroy_busket"
  get "/busket", to: "user_busket#show", as: "show_busket"

  get "/orders", to: "user_order#show", as: "show_user_order"
  delete "/orders/:id", to: "user_order#destroy", as: "destroy_user_order"
  post "/orders", to: "user_order#create", as: "create_user_order"
end
