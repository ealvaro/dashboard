class AddBillableAttributesToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :multiplier_as_billed, :float
    add_column :invoices, :discount_percent_as_billed, :float
  end
end
