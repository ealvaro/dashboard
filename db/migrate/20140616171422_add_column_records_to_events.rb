class AddColumnRecordsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :records, :string
  end
end
