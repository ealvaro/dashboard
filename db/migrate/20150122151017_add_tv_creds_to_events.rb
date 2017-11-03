class AddTvCredsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :team_viewer_id, :string
    add_column :events, :team_viewer_password, :string
  end
end
