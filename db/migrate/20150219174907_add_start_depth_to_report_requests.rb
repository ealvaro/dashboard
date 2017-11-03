class AddStartDepthToReportRequests < ActiveRecord::Migration
  def change
    add_column :report_requests, :start_depth, :float
  end
end
