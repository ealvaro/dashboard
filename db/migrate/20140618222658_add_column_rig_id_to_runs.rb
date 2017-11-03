class AddColumnRigIdToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :rig_id, :integer
  end
end
