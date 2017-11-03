class AddJobNumberAndRegionNameToTruckRequests < ActiveRecord::Migration
  def change
    add_column :truck_requests, :job_number, :string
    add_column :truck_requests, :region_name, :string
    add_index :truck_requests, :job_number
    add_index :truck_requests, :region_name
  end
end
