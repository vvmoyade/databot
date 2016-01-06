class AddUsersSlackToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slack_channel, :string
    add_column :users, :slack_url, :string
    add_column :users, :slack_token, :string
  end
end
