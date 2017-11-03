class AddOtherBillableFieldsToRunRecords < ActiveRecord::Migration
  def change
    add_column :run_records, :max_shock, :float
    add_column :run_records, :max_vibe, :float
    add_column :run_records, :shock_warnings, :integer
  end
end
