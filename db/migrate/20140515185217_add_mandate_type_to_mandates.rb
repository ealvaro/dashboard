class AddMandateTypeToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :mandate_type, :string
    add_column :mandates, :string, :string
  end
end
