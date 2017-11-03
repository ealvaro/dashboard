class CreateDirectionalDrillingTools < ActiveRecord::Migration
  def change
    create_table :directional_drilling_tools do |t|
      t.string :serial_number
      t.integer :directional_drilling_tool_type_id

      t.timestamps
    end
  end
end
