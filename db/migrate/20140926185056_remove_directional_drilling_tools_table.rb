class RemoveDirectionalDrillingToolsTable < ActiveRecord::Migration
  def change
    rename_column :run_records, :directional_drilling_tool_id, :tool_id
    remove_column :tools, :type
  end
end
