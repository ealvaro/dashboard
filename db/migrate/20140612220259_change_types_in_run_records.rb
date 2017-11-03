class ChangeTypesInRunRecords < ActiveRecord::Migration
  def change
    change_column :run_records, :assembled, :string
    change_column :run_records, :from_job, :string
    change_column :run_records, :from_shop, :string
  end
end
