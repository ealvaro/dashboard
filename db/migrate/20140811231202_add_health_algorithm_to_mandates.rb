class AddHealthAlgorithmToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :health_algorithm, :string
  end
end
