class RemoveMandateTypeFromMandates < ActiveRecord::Migration
  def change
    remove_column :mandates, :mandate_type, :string
  end
end
