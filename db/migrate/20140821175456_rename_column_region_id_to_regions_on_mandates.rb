class RenameColumnRegionIdToRegionsOnMandates < ActiveRecord::Migration
  def change
    remove_column :mandates, :region_id
    add_column :mandates, :regions, :string, array:true
  end
end
