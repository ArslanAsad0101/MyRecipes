class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :chef, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
