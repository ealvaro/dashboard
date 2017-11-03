class AddDgLiteMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :running_avg_window, :integer
  end
end
