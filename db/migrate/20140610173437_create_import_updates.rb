class CreateImportUpdates < ActiveRecord::Migration
  def change
    create_table :import_updates do |t|
      t.integer :import_id, null: false
      t.text :description, null: false
      t.string :update_type, null: false

      t.timestamps
    end
  end
end
