class AddNameToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :name, :string
  end
end
