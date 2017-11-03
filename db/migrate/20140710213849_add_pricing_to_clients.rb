class AddPricingToClients < ActiveRecord::Migration
  def change
    add_column :clients, :pricing, :json
  end
end
