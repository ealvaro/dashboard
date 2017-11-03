class AddHiddenToNotifiers < ActiveRecord::Migration
  def change
    add_column :notifiers, :hidden, :boolean, default: false
  end
end
