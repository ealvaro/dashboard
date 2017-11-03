class AddForSerialNumbersToFirmwareUpdates < ActiveRecord::Migration
  def change
    add_column :firmware_updates, :for_serial_numbers, :string
  end
end
