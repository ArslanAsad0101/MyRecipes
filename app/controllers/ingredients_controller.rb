class IngredientsController < ApplicationController
  before_action :require_chef!

  def index
    @ingredients = Ingredient.order(:name)
    @ingredient = Ingredient.new
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      redirect_to ingredients_path, notice: "Ingredient added successfully."
    else
      @ingredients = Ingredient.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
end
