class AddDamagesToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :damages, :json
  end
end
