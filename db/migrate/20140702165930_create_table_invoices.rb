class CreateTableInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :number
      t.date :date_of_issue
      t.float :discount_percent
      t.json :sent_to
    end
  end
end
