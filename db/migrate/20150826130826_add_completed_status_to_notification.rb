class AddCompletedStatusToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :completed_status, :string
  end
end
