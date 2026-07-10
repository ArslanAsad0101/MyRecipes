Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  root "pages#index"
  get "welcome", to: "pages#index"
  get "about", to: "pages#about"
  get "recipes", to: "recipes#index"
  get "recipes/new", to: "recipes#new", as: :new_recipe
  post "recipes", to: "recipes#create"
  get "recipes/:id", to: "recipes#show", as: :recipe
  get "recipes/:id/edit", to: "recipes#edit", as: :edit_recipe
  get "chefs", to: "pages#chefs", as: :chefs
  get "chefs/:id/recipes", to: "pages#chef_recipes", as: :chef_recipes
  patch "recipes/:id", to: "recipes#update"
  put "recipes/:id", to: "recipes#update"

  resources :recipes, only: [] do
    resources :comments, only: :create
    resources :recipe_likes, only: :create
  end

  resources :ingredients, only: %i[index new create]

  get "chef/signup", to: "pages#signup", as: :chef_signup
  post "chef/signup", to: "pages#create_chef"
  get "chef/login", to: "pages#login", as: :chef_login
  post "chef/login", to: "pages#create_login"
  delete "chef/logout", to: "pages#logout", as: :chef_logout
  get "contact", to: "pages#contact"
  get "chat", to: "conversations#index", as: :chat
  resources :conversations, only: %i[index create show] do
    resources :messages, only: :create
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
