class AddAddressToClients < ActiveRecord::Migration
  def change
    rename_column :clients, :address, :address_street
    add_column :clients, :address_city, :string
    add_column :clients, :zip_code, :string
    add_column :clients, :country, :string
  end
end
