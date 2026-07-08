class CreateRecipeLikesAndAddLikesCountToRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_likes do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :chef, null: true, foreign_key: true
      t.string :visitor_token

      t.timestamps
    end

    add_index :recipe_likes, [:recipe_id, :chef_id], unique: true
    add_index :recipe_likes, [:recipe_id, :visitor_token], unique: true

    add_column :recipes, :likes_count, :integer, null: false, default: 0
  end
end
