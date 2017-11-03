class AddColumnInvoiceIdToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :invoice_id, :integer
  end
end
