class AddColumnsToEventModel < ActiveRecord::Migration
  def change
    add_column :events, :memory_usage_level, :string
    add_column :events, :hardware_version, :string
    add_column :events, :reporter_version, :string
  end
end
