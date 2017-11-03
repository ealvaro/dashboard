class AddStatusListToTruckRequests < ActiveRecord::Migration
  def change
    add_column :truck_requests, :status_history, :hstore, array: true, default: []
    remove_column :truck_requests, :time, :datetime
    remove_column :truck_requests, :notes, :string
    remove_column :truck_requests, :status, :string
    add_column :truck_requests, :status, :json, default: {}
    remove_column :truck_requests, :region_name, :string
    remove_column :truck_requests, :job_number, :string
  end
end
