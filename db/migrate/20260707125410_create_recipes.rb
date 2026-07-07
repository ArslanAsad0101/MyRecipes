class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.string :category
      t.string :time

      t.timestamps
    end
  end
end
