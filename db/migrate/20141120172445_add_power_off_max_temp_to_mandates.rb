class AddPowerOffMaxTempToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :power_off_max_temp, :float
  end
end
