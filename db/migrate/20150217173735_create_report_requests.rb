class CreateReportRequests < ActiveRecord::Migration
  def change
    create_table :report_requests do |t|
      t.float :measured_depth
      t.float :inc
      t.float :azm
      t.integer :job_id
      t.datetime :succeeded_at
      t.datetime :failed_at
      t.integer :run_id
      t.text :description
      t.string :report_request_type
      t.timestamps
    end
  end
end
