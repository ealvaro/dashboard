class AddSamplePeriodToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :sample_period, :integer
  end
end
