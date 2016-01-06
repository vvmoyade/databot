class AddSchedulerIdToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :scheduler_id, :integer,default: 1
  end
end
