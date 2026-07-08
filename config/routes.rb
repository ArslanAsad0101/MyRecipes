Rails.application.routes.draw do
  root "welcome#index"
  get "welcome", to: "welcome#index"
  get "about", to: "welcome#about"
  get "recipes", to: "welcome#recipes"
  get "recipes/new", to: "welcome#new", as: :new_recipe
  post "recipes", to: "welcome#create"
  get "recipes/:id/edit", to: "welcome#edit", as: :edit_recipe
  patch "recipes/:id", to: "welcome#update", as: :recipe
  put "recipes/:id", to: "welcome#update"
  get "chef/signup", to: "welcome#signup", as: :chef_signup
  post "chef/signup", to: "welcome#create_chef"
  get "chef/login", to: "welcome#login", as: :chef_login
  post "chef/login", to: "welcome#create_login"
  delete "chef/logout", to: "welcome#logout", as: :chef_logout
  get "contact", to: "welcome#contact"

  get "up" => "rails/health#show", as: :rails_health_check
end
