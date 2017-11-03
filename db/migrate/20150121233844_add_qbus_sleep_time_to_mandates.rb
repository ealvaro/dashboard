class AddQbusSleepTimeToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :qbus_sleep_time, :integer
  end
end
