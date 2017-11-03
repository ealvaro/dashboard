class AddDamagesAsBilledToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :damages_as_billed, :json
  end
end
