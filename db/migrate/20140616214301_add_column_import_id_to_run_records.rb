class AddColumnImportIdToRunRecords < ActiveRecord::Migration
  def change
    add_column :run_records, :import_id, :integer
  end
end
