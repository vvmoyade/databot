class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :profile_index
      t.string :name
      t.boolean :users
      t.boolean :newUsers
      t.boolean :conversions
      t.boolean :pageviews
      t.boolean :avgSessionDuration
      t.boolean :totalEvents
      t.boolean :sessions
      t.integer :mywebsite_id

      t.timestamps null: false
    end
  end
end
