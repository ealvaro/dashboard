class RemoveTruckRequestIdDups < ActiveRecord::Migration
  def change
    remove_column :jobs, :truck_request_id, :integer
    remove_column :regions, :truck_request_id, :integer
  end
end
