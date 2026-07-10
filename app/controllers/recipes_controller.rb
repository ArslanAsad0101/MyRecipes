class RecipesController < ApplicationController
  before_action :require_chef!, only: %i[new create edit update]

  def index
    redirect_to chef_signup_path, alert: "Please sign up as a chef to view your recipes." unless chef_signed_in?
    return if performed?

    @recipes = current_chef.recipes.includes(:chef, :ingredients).order(created_at: :desc)
    render "pages/recipes"
  end

  def new
    @recipe = Recipe.new
    render "pages/new"
  end

  def create
    @recipe = current_chef.recipes.new(recipe_params.except(:image_file, :remove_image))
    process_recipe_image(@recipe)

    if @recipe.save
      redirect_to recipes_path, notice: "Recipe created successfully."
    else
      render "pages/new", status: :unprocessable_entity
    end
  end

  def show
    @recipe = Recipe.includes(:chef, :ingredients, comments: :chef).find(params[:id])
    @comments = @recipe.comments.order(created_at: :desc)
    @comment = Comment.new
    render "pages/show"
  end

  def edit
    @recipe = current_chef.recipes.find_by(id: params[:id])
    raise AccessDenied if @recipe.nil?

    render "pages/edit"
  end

  def update
    @recipe = current_chef.recipes.find_by(id: params[:id])
    raise AccessDenied if @recipe.nil?

    @recipe.assign_attributes(recipe_params.except(:image_file, :remove_image))
    process_recipe_image(@recipe)

    if @recipe.save
      redirect_to recipes_path, notice: "Recipe updated successfully."
    else
      render "pages/edit", status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :category, :time, :image_file, :remove_image, ingredient_ids: [])
  end

  def process_recipe_image(recipe)
    return unless params[:recipe].present?

    if params[:recipe][:image_file].present?
      save_uploaded_image(recipe)
    elsif params[:recipe][:remove_image] == "1"
      recipe.image = "default_recipe.svg"
    end
  end

  def save_uploaded_image(recipe)
    uploaded_file = params[:recipe][:image_file]
    return unless uploaded_file.respond_to?(:original_filename)

    directory = Rails.root.join("public", "uploads", "recipes")
    FileUtils.mkdir_p(directory)

    filename = "#{SecureRandom.uuid}_#{sanitize_filename(uploaded_file.original_filename)}"
    path = directory.join(filename)

    File.open(path, "wb") do |file|
      file.write(uploaded_file.read)
    end

    recipe.image = "/uploads/recipes/#{filename}"
  end

  def sanitize_filename(name)
    File.basename(name).gsub(/[^-\u007F]/, "_").gsub(/[^0-9A-Za-z.\-]/, "_")
  end
end
