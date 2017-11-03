class AddSettingsToPulserMandate < ActiveRecord::Migration
  def change
    add_column :mandates, :batt_hi_thresh, :float
    add_column :mandates, :batt_lo_thresh, :float
  end
end
