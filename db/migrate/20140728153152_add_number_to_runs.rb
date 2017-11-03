class AddNumberToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :number, :integer
  end
end
