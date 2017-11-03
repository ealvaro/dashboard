class AddEndDepthToReportRequests < ActiveRecord::Migration
  def change
    add_column :report_requests, :end_depth, :float
  end
end
