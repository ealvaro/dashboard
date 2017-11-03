class AddFormationMultiplierToFormations < ActiveRecord::Migration
  def change
    add_column :formations, :multiplier, :float
  end
end
