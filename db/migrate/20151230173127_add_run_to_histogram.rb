class AddRunToHistogram < ActiveRecord::Migration
  def change
    remove_column :histograms, :data, :hstore
    remove_column :histograms, :data_type, :string
    add_column :histograms, :run_id, :integer
    add_column :histograms, :data, :json
  end
end
