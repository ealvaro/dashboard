class CreateFirmwareUpdates < ActiveRecord::Migration
  def change
    create_table :firmware_updates do |t|
      t.string :tool_type, index: true, allow_nil: false
      t.string :version, allow_nil: false
      t.text   :summary, allow_nil: false
      t.string :binary, allow_nil: false
      t.string :hardware_version, allow_nil: false
      t.string :contexts, array: true

      t.timestamps
    end
  end
end
