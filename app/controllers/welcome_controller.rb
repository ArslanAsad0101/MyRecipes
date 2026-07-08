class WelcomeController < ApplicationController
  before_action :require_chef!, only: %i[new create edit update]

  def index
    @featured_recipes = Recipe.includes(:chef, :ingredients).order(created_at: :desc)
  end

  def about
  end

  def recipes
    redirect_to chef_signup_path, alert: "Please sign up as a chef to view your recipes." unless chef_signed_in?
    return if performed?

    @recipes = current_chef.recipes.includes(:chef, :ingredients).order(created_at: :desc)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_chef.recipes.new(recipe_params)

    if @recipe.save
      redirect_to recipes_path, notice: "Recipe created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipe = current_chef.recipes.find(params[:id])
  end

  def update
    @recipe = current_chef.recipes.find(params[:id])

    if @recipe.update(recipe_params)
      redirect_to recipes_path, notice: "Recipe updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def signup
    @chef = Chef.new
  end

  def create_chef
    @chef = Chef.new(chef_params)

    if @chef.save
      session[:chef_id] = @chef.id
      cookies.signed[:chef_id] = { value: @chef.id, httponly: true, same_site: :lax }
      redirect_to recipes_path, notice: "Chef account created successfully."
    else
      render :signup, status: :unprocessable_entity
    end
  end

  def login
    @chef = Chef.new
  end

  def create_login
    @chef = Chef.find_by(email: params[:chef][:email])

    if @chef&.authenticate(params[:chef][:password])
      session[:chef_id] = @chef.id
      cookies.signed[:chef_id] = { value: @chef.id, httponly: true, same_site: :lax }
      redirect_to recipes_path, notice: "Welcome back, #{@chef.name}."
    else
      @chef = Chef.new(email: params[:chef][:email])
      flash.now[:alert] = "Invalid email or password."
      render :login, status: :unprocessable_entity
    end
  end

  def logout
    session[:chef_id] = nil
    cookies.delete(:chef_id)
    redirect_to recipes_path, notice: "You have been logged out."
  end

  def contact
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :category, :time, ingredient_ids: [])
  end

  def chef_params
    params.require(:chef).permit(:name, :email, :password, :password_confirmation)
  end
end