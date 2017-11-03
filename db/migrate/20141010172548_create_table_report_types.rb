class CreateTableReportTypes < ActiveRecord::Migration
  def change
    create_table :report_types do |t|
      t.string :name
      t.boolean :active
      t.timestamps
    end
  end
end
