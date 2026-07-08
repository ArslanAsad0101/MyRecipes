class AddImageToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :image, :string, null: false, default: "default_recipe.svg"
  end
end
