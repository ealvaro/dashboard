class AddColumnWellIdToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :well_id, :integer
  end
end
