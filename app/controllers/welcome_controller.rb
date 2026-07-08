class WelcomeController < ApplicationController
  def index
    @featured_recipes = Recipe.order(:created_at).limit(3)
  end

  def about
  end

  def recipes
    @recipes = Recipe.order(:created_at).reverse_order
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to recipes_path, notice: "Recipe created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.update(recipe_params)
      redirect_to recipes_path, notice: "Recipe updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def contact
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :category, :time)
  end
end