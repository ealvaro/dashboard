class AddTruckRequestForeignKeys < ActiveRecord::Migration
  def change
    add_column :jobs, :truck_request_id, :integer
    add_column :regions, :truck_request_id, :integer
  end
end
