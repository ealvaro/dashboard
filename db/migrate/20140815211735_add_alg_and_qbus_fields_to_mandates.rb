class AddAlgAndQbusFieldsToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :gamma_np, :string
    add_column :mandates, :tolteq_survey, :string
  end
end
