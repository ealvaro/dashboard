class RemoveIndexNameFromDirectionalDrillingToolTypes < ActiveRecord::Migration
  def change
    remove_index :directional_drilling_tool_types, :name
  end
end
