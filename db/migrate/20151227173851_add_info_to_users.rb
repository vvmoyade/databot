class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile, :string
    add_column :users, :name, :string
  end
end
