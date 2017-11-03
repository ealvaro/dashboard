class RenameVibrationAndBatteryUpdates < ActiveRecord::Migration
  def change
     rename_column :updates, :vibration, :frequency
     rename_column :updates, :battery, :battery_number
  end
end
