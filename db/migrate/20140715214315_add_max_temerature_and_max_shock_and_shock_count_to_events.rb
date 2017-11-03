class AddMaxTemeratureAndMaxShockAndShockCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :max_temperature, :float
    add_column :events, :max_shock, :float
    add_column :events, :shock_count, :integer
  end
end
