class AddTimeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :hours, :integer,:default=>0
    add_column :profiles, :minutes, :integer,:default=>0
  end
end
