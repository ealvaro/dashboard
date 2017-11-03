class RemoveCacheFromReceivers < ActiveRecord::Migration
  def change
    remove_column :receivers, :cache, :json
  end
end
