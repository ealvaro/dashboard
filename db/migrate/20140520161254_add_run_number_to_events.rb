class AddRunNumberToEvents < ActiveRecord::Migration
  def change
    add_column :events, :run_number, :integer
  end
end
