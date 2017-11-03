class AddDellServiceNumberToInstalls < ActiveRecord::Migration
  def change
    add_column :installs, :dell_service_number, :string
  end
end
