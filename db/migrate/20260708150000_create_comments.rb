class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :chef, null: false, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
