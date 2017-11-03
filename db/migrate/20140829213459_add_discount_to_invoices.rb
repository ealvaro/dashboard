class AddDiscountToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :discount_in_cents, :integer
  end
end
