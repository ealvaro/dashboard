class AddShockAndVibeToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :max_shock_as_billed, :float
    add_column :runs, :max_vibe_as_billed, :float
    add_column :runs, :shock_warnings_as_billed, :integer
  end
end
