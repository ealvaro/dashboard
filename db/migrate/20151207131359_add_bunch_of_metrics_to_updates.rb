class AddBunchOfMetricsToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :battery, :integer
    add_column :updates, :annular_pressure, :float
    add_column :updates, :bore_pressure, :float
    add_column :updates, :delta_mtf, :float
    add_column :updates, :dl_power, :float
    add_column :updates, :dl_enabled, :boolean
    add_column :updates, :formation_resistance, :float
    add_column :updates, :signal, :float
    add_column :updates, :noise, :float
    add_column :updates, :s_n_ratio, :float
    add_column :updates, :mag_dec, :float
    add_column :updates, :grav_roll, :float
    add_column :updates, :mag_roll, :float
    add_column :updates, :gamma_shock, :float
    add_column :updates, :gamma_shock_axial_p, :float
    add_column :updates, :gamma_shock_tran_p, :float
    add_column :updates, :tfo, :float
  end
end
