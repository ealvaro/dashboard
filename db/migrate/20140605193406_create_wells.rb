class CreateWells < ActiveRecord::Migration
  def change
    create_table :wells do |t|
      t.string :name
      t.integer :formation_id

      t.timestamps
    end
  end
end
