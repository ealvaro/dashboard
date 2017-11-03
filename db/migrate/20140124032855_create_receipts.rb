class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.string :mandate_token, allow_nil: false, index: true
      t.datetime :timestamp_utc, allow_nil: false
      t.string :tool_serial, allow_nil: false

      t.timestamps
    end
  end
end
