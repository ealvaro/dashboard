class CreateTableExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.integer :exportable_id
      t.string :exportable_type
      t.string :file
    end
  end
end
