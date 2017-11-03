class AddColumnsToInstalls < ActiveRecord::Migration
  def change
    add_column :installs, :team_viewer_id, :string
    add_column :installs, :team_viewer_password, :string
    add_column :installs, :user_email, :string
    add_column :installs, :region, :string
    add_column :installs, :reporter_context, :string
    add_column :installs, :job_number, :string
    add_column :installs, :run_number, :string
  end
end
