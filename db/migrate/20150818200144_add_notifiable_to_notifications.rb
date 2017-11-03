class AddNotifiableToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notifiable_type, :string
    add_column :notifications, :notifiable_id, :integer
  end
end
