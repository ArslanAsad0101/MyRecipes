class AddChefReferenceToRecipes < ActiveRecord::Migration[8.1]
  def up
    create_table :chefs do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.timestamps
    end

    add_index :chefs, :email, unique: true

    add_reference :recipes, :chef, foreign_key: true

    chef = Chef.create!(name: "Default Chef", email: "default@myrecipes.dev")
    Recipe.reset_column_information
    Recipe.update_all(chef_id: chef.id)

    change_column_null :recipes, :chef_id, false
  end

  def down
    remove_reference :recipes, :chef
    drop_table :chefs
  end
end
