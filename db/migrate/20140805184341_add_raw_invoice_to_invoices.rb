class AddRawInvoiceToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :raw_invoice, :json
  end
end
