class InstallSerializer < ActiveModel::Serializer
  attributes :id, :application_name, :version, :ip_address, :key, :created_at, :updated_at
  attributes :team_viewer_id, :team_viewer_password, :dell_service_number, :user_email, :region, :reporter_context
  attributes :job_number, :run_number, :computer_category
end
