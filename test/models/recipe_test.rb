require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test "can attach ingredients when creating a recipe" do
    chef = Chef.create!(name: "Chef A", email: "chef_a@example.com", password: "password123", password_confirmation: "password123")
    ingredient = Ingredient.create!(name: "Salt")

    recipe = chef.recipes.build(
      title: "Pasta",
      description: "A simple pasta dish",
      category: "Dinner",
      time: "20 min",
      ingredient_ids: [ingredient.id]
    )

    assert recipe.save
    assert_includes recipe.ingredients, ingredient
  end
end
