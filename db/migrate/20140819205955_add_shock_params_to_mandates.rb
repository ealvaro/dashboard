class AddShockParamsToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :shock_radial, :string
    add_column :mandates, :shock_axial, :string
  end
end
