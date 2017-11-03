class DropColumnsFromRunRecords < ActiveRecord::Migration
  def change
    remove_column :run_records, :assembled, :string
  end
end
