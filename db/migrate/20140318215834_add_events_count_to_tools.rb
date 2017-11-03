class AddEventsCountToTools < ActiveRecord::Migration
  def change
    add_column :tools, :events_count, :integer, default: 0
  end
end
