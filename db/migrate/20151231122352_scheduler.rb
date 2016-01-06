class Scheduler < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
