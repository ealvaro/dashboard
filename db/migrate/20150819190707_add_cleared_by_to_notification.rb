class AddClearedByToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :cleared_by_id, :int
  end
end
