class AddLastEditByToFirmwareUpdates < ActiveRecord::Migration
  def change
    add_column :firmware_updates, :last_edit_by_id, :integer
  end
end
