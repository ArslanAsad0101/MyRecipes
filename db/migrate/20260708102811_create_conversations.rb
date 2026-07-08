class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.integer :chef_a_id
      t.integer :chef_b_id

      t.timestamps
    end
    add_index :conversations, %i[chef_a_id chef_b_id], unique: true
  end
end
