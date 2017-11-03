class AddNameToEventAsset < ActiveRecord::Migration
  def change
    add_column :event_assets, :name, :string
  end
end
