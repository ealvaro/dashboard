class CreateImport < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :user_id, null: false
      t.boolean :persist, null: false

      t.timestamps
    end
  end
end
