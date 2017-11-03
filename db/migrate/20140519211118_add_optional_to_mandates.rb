class AddOptionalToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :optional, :boolean, :default => false
  end
end
