class CreateTruckRequests < ActiveRecord::Migration
  def change
    create_table :truck_requests do |t|
      t.integer :job_id
      t.string :job_number
      t.integer :region_id
      t.string :priority
      t.datetime :time
      t.string :user_email
      t.string :computer_identifier
      t.string :motors
      t.string :mwd_tools
      t.string :surface_equipment
      t.string :backhaul
      t.string :notes
      t.string :status

      t.timestamps
    end

    add_index :truck_requests, :job_id
    add_index :truck_requests, :job_number
  end
end