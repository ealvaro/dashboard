class CreateCsvFile < ActiveRecord::Migration
  def change
    create_table :csv_files do |t|
      t.integer :import_id
      t.string :file
    end
  end
end
