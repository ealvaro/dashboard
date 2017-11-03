class CreateHistograms < ActiveRecord::Migration
  def change
    create_table :histograms do |t|
      t.string :name
      t.integer :tool_id
      t.float :temperature
      t.float :radial_shock
      t.float :axial_shock
      t.float :radial_vibration
      t.float :axial_vibration
      t.float :total

      t.timestamps
    end
  end
end