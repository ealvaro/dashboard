class AddUidToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :uid, :string
  end
end
