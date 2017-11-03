class AddSifThresholdToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :sif_threshold, :float
  end
end
