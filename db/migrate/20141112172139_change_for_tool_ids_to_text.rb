class ChangeForToolIdsToText < ActiveRecord::Migration
  def change
    change_column :mandates, :for_tool_ids, :text
  end
end
