class AddCacheToReceivers < ActiveRecord::Migration
  def change
    add_column :receivers, :cache, :json
  end
end
