class RemoveTableDirectionalDrillingTool < ActiveRecord::Migration
  def up
    drop_table :directional_drilling_tools
  end
  def down
    create_table "directional_drilling_tools", force: true do |t|
      t.string   "serial_number"
      t.integer  "directional_drilling_tool_type_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
