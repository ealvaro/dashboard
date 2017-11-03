class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.belongs_to :report_type, index: true
      t.string :name
      t.boolean :active
      t.timestamps
    end
  end
end
