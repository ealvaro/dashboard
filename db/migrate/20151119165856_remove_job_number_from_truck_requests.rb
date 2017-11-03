class RemoveJobNumberFromTruckRequests < ActiveRecord::Migration
  def change
    remove_column :truck_requests, :job_number, :string
  end
end
