class AddRequestedByToReportRequests < ActiveRecord::Migration
  def change
    add_column :report_requests, :requested_by_id, :integer
  end
end
