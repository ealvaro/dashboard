class AddCacheToTools < ActiveRecord::Migration
  def change
    add_column :tools, :cache, :json
  end
end
