require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chef = Chef.create!(name: "Test Chef", email: "test-chef@example.com", password: "password")
    post chef_login_path, params: { chef: { email: @chef.email, password: "password" } }
  end

  test "creates a recipe and stores it in the database" do
    assert_difference("Recipe.count", 1) do
      post recipes_path, params: {
        recipe: {
          title: "Creamy Tomato Soup",
          description: "A cozy bowl for chilly evenings.",
          category: "Dinner",
          time: "25 min"
        }
      }
    end

    assert_redirected_to recipes_path
    assert_equal "Creamy Tomato Soup", Recipe.last.title
  end

  test "updates an existing recipe and persists the change" do
    recipe = Recipe.create!(title: "Old Title", description: "Old description", category: "Lunch", time: "10 min", chef: @chef)

    patch recipe_path(recipe), params: {
      recipe: {
        title: "Updated Title",
        description: "Updated description",
        category: "Dinner",
        time: "20 min"
      }
    }

    assert_redirected_to recipes_path
    assert_equal "Updated Title", recipe.reload.title
    assert_equal "Updated description", recipe.reload.description
  end

  test "shows all chefs with their recipe counts" do
    other_chef = Chef.create!(name: "Other Chef", email: "other-chef@example.com", password: "password")
    Recipe.create!(title: "Soup", description: "Warm soup", category: "Dinner", time: "15 min", chef: @chef)
    Recipe.create!(title: "Salad", description: "Fresh salad", category: "Lunch", time: "10 min", chef: other_chef)

    get chefs_path

    assert_response :success
    assert_select "h2", /Chefs/
    assert_select "a[href=?]", chef_recipes_path(other_chef)
  end

  test "shows recipes for a selected chef" do
    other_chef = Chef.create!(name: "Other Chef", email: "other-chef@example.com", password: "password")
    recipe = Recipe.create!(title: "Salad", description: "Fresh salad", category: "Lunch", time: "10 min", chef: other_chef)

    get chef_recipes_path(other_chef)

    assert_response :success
    assert_select "h3", recipe.title
  end
end
