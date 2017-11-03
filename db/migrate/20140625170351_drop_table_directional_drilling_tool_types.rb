class DropTableDirectionalDrillingToolTypes < ActiveRecord::Migration
  def up
    drop_table :directional_drilling_tool_types
  end
  def down
    create_table "directional_drilling_tool_types", force: true do |t|
      t.string   "name",        null: false
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
