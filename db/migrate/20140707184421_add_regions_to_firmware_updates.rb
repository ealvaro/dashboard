class AddRegionsToFirmwareUpdates < ActiveRecord::Migration
  def change
    add_column :firmware_updates, :regions, :string, :array => true
  end
end
