class RemoveLivelogFromUpdates < ActiveRecord::Migration
  def change
    remove_column :updates, :livelog, :boolean
    remove_column :updates, :com3, :string
    remove_column :updates, :com6, :string
  end
end
