class UpdateHistogramToHstoreArray < ActiveRecord::Migration
  def change
    remove_column :histograms, :temperature, :float
    remove_column :histograms, :radial_shock, :float
    remove_column :histograms, :axial_shock, :float
    remove_column :histograms, :radial_vibration, :float
    remove_column :histograms, :axial_vibration, :float
    add_column :histograms, :temperature, :hstore, array: true, default: []
    add_column :histograms, :radial_shock, :hstore, array: true, default: []
    add_column :histograms, :axial_shock, :hstore, array: true, default: []
    add_column :histograms, :radial_vibration, :hstore, array: true, default: []
    add_column :histograms, :axial_vibration, :hstore, array: true, default: []
  end
end
