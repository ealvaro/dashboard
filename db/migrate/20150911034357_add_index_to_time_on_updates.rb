class AddIndexToTimeOnUpdates < ActiveRecord::Migration
  def change
    add_index :updates, :time
    add_index :updates, :updated_at
  end
end
