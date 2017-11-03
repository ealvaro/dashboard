class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name, unique: true, index: true, allow_nil: false
      t.boolean :active, default: true, allow_nil: false

      t.timestamps
    end
  end
end
