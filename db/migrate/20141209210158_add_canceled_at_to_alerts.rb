class AddCanceledAtToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :canceled_at, :datetime
  end
end
