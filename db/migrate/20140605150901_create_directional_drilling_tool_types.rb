class CreateDirectionalDrillingToolTypes < ActiveRecord::Migration
  def change
    create_table :directional_drilling_tool_types do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :directional_drilling_tool_types, :name, unique: true
  end
end
