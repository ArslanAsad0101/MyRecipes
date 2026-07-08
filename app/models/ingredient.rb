class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  before_validation :normalize_name

  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "is already in ingredient list" }

  private

  def normalize_name
    self.name = name.to_s.strip.titleize if name.present?
  end
end
