class AddServiceAndJobsToHistograms < ActiveRecord::Migration
  def change
    add_column :histograms, :service_number, :integer
    add_column :histograms, :job_id, :integer
    add_column :histograms, :data, :hstore, array: true
    add_column :histograms, :data_type, :string
    remove_column :histograms, :total, :float
    remove_column :histograms, :temperature, :hstore
    remove_column :histograms, :axial_shock, :hstore
    remove_column :histograms, :radial_shock, :hstore
    remove_column :histograms, :axial_vibration, :hstore
    remove_column :histograms, :radial_vibration, :hstore
  end
end
