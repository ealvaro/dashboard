class ChangeColumnSandToFloat < ActiveRecord::Migration
  def up
    change_column :run_records, :sand, :float
  end

  def down
    change_column :run_records, :sand, :integer
  end
end
