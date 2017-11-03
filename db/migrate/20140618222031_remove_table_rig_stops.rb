class RemoveTableRigStops < ActiveRecord::Migration
  def up
    drop_table :rig_stops
  end
  def down
    create_table :rig_stops do |t|
      t.integer :well_id
      t.integer :rig_id

      t.timestamps
    end
  end
end
