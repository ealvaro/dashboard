class AddColumnsToRunRecords < ActiveRecord::Migration
  def change
    add_column :run_records, :bha, :integer
    add_column :run_records, :agitator_distance, :float
    add_column :run_records, :mud_type, :string
  end
end
