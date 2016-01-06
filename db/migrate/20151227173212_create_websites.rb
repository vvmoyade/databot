class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|

      t.timestamps null: false
      t.string :website_url
    end
  end
end
