class RenameWebsiteToMywebsite < ActiveRecord::Migration
  def change
    rename_table :websites, :mywebsites
  end
end
