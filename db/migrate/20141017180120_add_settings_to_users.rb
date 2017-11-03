class AddSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :settings, :json
  end
end
