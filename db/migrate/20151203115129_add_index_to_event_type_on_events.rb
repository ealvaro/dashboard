class AddIndexToEventTypeOnEvents < ActiveRecord::Migration
  def change
    add_index :events, :event_type
  end
end
