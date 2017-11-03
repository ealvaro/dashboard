class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :tool, index: true
      t.string :event_type, allow_nil: false
      t.datetime :time, allow_nil: false
      t.string :reporter_type, allow_nil: false
      t.string :software_installation_id, allow_nil: false
      t.string :board_firmware_version, allow_nil: false
      t.string :board_serial_number, allow_nil: false
      t.string :chassis_serial_number, allow_nil: false
      t.string :primary_asset_number, allow_nil: false
      t.string :secondary_asset_numbers
      t.string :user_email
      t.string :region
      t.text :notes
      t.string :asset

      t.timestamps
    end
  end
end
