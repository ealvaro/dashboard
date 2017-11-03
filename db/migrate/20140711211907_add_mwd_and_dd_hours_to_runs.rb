class AddMwdAndDdHoursToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :mwd_hours_as_billed, :float
    add_column :runs, :dd_hours_as_billed, :float
  end
end
