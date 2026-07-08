class Recipe < ApplicationRecord
  belongs_to :chef
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  validates :title, :description, :category, presence: true
end
