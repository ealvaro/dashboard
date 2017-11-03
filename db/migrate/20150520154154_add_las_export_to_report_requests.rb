class AddLasExportToReportRequests < ActiveRecord::Migration
  def change
    add_column :report_requests, :las_export, :bool
    add_column :report_requests, :request_correction, :bool
  end
end
