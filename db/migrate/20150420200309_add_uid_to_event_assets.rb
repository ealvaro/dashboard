class AddUidToEventAssets < ActiveRecord::Migration
  def change
    add_column :event_assets, :uid, :string
  end
end
