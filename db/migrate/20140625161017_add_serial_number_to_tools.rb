class AddSerialNumberToTools < ActiveRecord::Migration
  def change
    add_column :tools, :serial_number, :string
  end
end
