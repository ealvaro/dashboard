class AddLowPulseThresholdToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :low_pulse_threshold, :float
  end
end
