class AddTotalToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :total_in_cents, :integer
  end
end
