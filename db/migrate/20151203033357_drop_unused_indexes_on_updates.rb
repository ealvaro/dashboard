class DropUnusedIndexesOnUpdates < ActiveRecord::Migration
  def change
    remove_index :updates, column: :client_id
    remove_index :updates, column: :rig_id
    remove_index :updates, column: :well_id
  end
end
