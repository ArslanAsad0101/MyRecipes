class AddPasswordDigestToChefs < ActiveRecord::Migration[8.1]
  def change
    add_column :chefs, :password_digest, :string
  end
end
