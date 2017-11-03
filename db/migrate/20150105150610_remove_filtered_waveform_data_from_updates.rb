class RemoveFilteredWaveformDataFromUpdates < ActiveRecord::Migration
  def change
    remove_column :updates, :filtered_waveform_data, :json
  end
end
