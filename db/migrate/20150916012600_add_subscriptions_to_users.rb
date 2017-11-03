class AddSubscriptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :follows, :string, array: true, default: []
  end
end
