class RemoveColumnsFromRunRecords < ActiveRecord::Migration
  def change
    remove_column :run_records, :from_job, :string
    remove_column :run_records, :from_shop, :string
    remove_column :run_records, :incident, :string
    remove_column :run_records, :ci_incident, :string
    remove_column :run_records, :mwd_comment, :string
  end
end
