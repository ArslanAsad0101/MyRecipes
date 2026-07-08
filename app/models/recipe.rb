class Recipe < ApplicationRecord
  belongs_to :chef
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, dependent: :destroy
  has_many :recipe_likes, dependent: :destroy

  validates :title, :description, :category, presence: true
end
