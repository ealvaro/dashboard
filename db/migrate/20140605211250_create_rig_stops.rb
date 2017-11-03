class CreateRigStops < ActiveRecord::Migration
  def change
    create_table :rig_stops do |t|
      t.integer :well_id
      t.integer :rig_id

      t.timestamps
    end
  end
end
