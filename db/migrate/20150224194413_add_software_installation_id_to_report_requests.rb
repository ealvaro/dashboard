class AddSoftwareInstallationIdToReportRequests < ActiveRecord::Migration
  def change
    add_column :report_requests, :software_installation_id, :string
    add_column :report_requests, :completed_by, :string
  end
end
