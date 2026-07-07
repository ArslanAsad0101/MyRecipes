class WelcomeController < ApplicationController
  def index
    @featured_recipes = Recipe.order(:created_at).limit(3)
  end

  def about
  end

  def recipes
    @recipes = Recipe.all
  end

  def contact
  end
end 