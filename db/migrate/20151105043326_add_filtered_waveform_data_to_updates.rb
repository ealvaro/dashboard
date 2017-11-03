class AddFilteredWaveformDataToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :filtered_waveform_data, :json
  end
end
