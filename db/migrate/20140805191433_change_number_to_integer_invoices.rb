class ChangeNumberToIntegerInvoices < ActiveRecord::Migration
  def up
    change_column :invoices, :number, :string
  end
  def down
    change_column :invoices, :number, :integer
  end
end