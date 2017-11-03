class AddPowerAndVibrationToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :power, :float
    add_column :updates, :vibration, :float
  end
end
