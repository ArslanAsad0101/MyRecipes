Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  root "welcome#index"
  get "welcome", to: "welcome#index"
  get "about", to: "welcome#about"
  get "recipes", to: "welcome#recipes"
  get "recipes/new", to: "welcome#new", as: :new_recipe
  post "recipes", to: "welcome#create"
  get "recipes/:id", to: "welcome#show", as: :recipe
  get "recipes/:id/edit", to: "welcome#edit", as: :edit_recipe
  get "chefs", to: "welcome#chefs", as: :chefs
  get "chefs/:id/recipes", to: "welcome#chef_recipes", as: :chef_recipes
  patch "recipes/:id", to: "welcome#update"
  put "recipes/:id", to: "welcome#update"

  resources :recipes, only: [] do
    resources :comments, only: :create
  end
  get "chef/signup", to: "welcome#signup", as: :chef_signup
  post "chef/signup", to: "welcome#create_chef"
  get "chef/login", to: "welcome#login", as: :chef_login
  post "chef/login", to: "welcome#create_login"
  delete "chef/logout", to: "welcome#logout", as: :chef_logout
  get "contact", to: "welcome#contact"
  get "chat", to: "conversations#index", as: :chat
  resources :conversations, only: %i[index create show] do
    resources :messages, only: :create
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
