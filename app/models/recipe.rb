class Recipe < ApplicationRecord
  belongs_to :chef
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, dependent: :destroy
  has_many :recipe_likes, dependent: :destroy

  after_create_commit :broadcast_prepend_to_recipes

  validates :title, :description, :category, presence: true

  def image_url
    return ActionController::Base.helpers.asset_path("default_recipe.svg") if image.blank? || image == "default_recipe.svg"

    image.start_with?("/") ? image : ActionController::Base.helpers.asset_path(image)
  end

  private

  def broadcast_prepend_to_recipes
    broadcast_prepend_to :recipes, target: :recipes, partial: "welcome/recipe_card", locals: { recipe: self }
  end
end
