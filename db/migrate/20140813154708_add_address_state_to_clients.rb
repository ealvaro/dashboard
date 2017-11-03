class AddAddressStateToClients < ActiveRecord::Migration
  def change
    add_column :clients, :address_state, :string
  end
end
