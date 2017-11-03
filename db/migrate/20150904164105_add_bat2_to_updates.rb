class AddBat2ToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :bat2, :boolean
  end
end
