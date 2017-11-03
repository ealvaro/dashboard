class RenameColumnMaxTemperatureRunRecords < ActiveRecord::Migration
  def up
    rename_column :run_records, :mas_temperature, :max_temperature
  end
  def down
    rename_column :run_records, :max_temperature, :mas_temperature
  end
end
