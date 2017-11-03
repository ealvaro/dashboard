class AddNotesToTruckRequest < ActiveRecord::Migration
  def change
    add_column :truck_requests, :notes, :string
  end
end
