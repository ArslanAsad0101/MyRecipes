Rails.application.routes.draw do
  root "welcome#index"
  get "welcome", to: "welcome#index"
  get "about", to: "welcome#about"
  get "recipes", to: "welcome#recipes"
  get "contact", to: "welcome#contact"

  get "up" => "rails/health#show", as: :rails_health_check
end
