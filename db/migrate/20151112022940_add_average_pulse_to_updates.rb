class AddAveragePulseToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :average_pulse, :float
  end
end
