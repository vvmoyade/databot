class AddUserToWebsiteReference < ActiveRecord::Migration
  def change
    add_reference :mywebsites, :user, index: true, foreign_key: true
  end
end
