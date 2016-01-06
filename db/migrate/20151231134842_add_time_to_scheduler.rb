class AddTimeToScheduler < ActiveRecord::Migration
  def change
    add_column :schedulers, :hours, :integer,:default=>0
    add_column :schedulers, :minutes, :integer,:default=>0
  end
end
