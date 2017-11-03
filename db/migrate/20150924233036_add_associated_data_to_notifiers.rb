class AddAssociatedDataToNotifiers < ActiveRecord::Migration
  def change
    add_column :notifiers, :associated_data, :json unless column_exists? :notifiers, :associated_data
  end
end
