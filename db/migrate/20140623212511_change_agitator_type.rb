class ChangeAgitatorType < ActiveRecord::Migration
  def up
    remove_column :run_records, :agitator
    add_column :run_records, :agitator, :string
  end

  def down
    remove_column :run_records, :agitator
    add_column :run_records, :agitator, :float
  end
end
