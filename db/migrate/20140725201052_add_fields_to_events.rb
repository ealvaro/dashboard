class AddFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :run_id, :integer
    add_column :events, :client_name, :string
    add_column :events, :well_name, :string
    add_column :events, :rig_name, :string
  end
end
