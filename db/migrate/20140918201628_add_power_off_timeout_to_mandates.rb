class AddPowerOffTimeoutToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :power_off_timeout, :integer
  end
end
