class RenameColumnRecordsEvents < ActiveRecord::Migration
  def change
    rename_column :events, :records, :tags
  end
end
