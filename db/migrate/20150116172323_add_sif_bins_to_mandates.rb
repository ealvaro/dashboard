class AddSifBinsToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :sif_bin_0_max5, :integer
    add_column :mandates, :sif_bin_1_max5, :integer
    add_column :mandates, :sif_bin_2_max5, :integer
    add_column :mandates, :sif_bin_3_max5, :integer

    add_column :mandates, :sif_bin_0_max30, :integer
    add_column :mandates, :sif_bin_1_max30, :integer
    add_column :mandates, :sif_bin_2_max30, :integer
    add_column :mandates, :sif_bin_3_max30, :integer
    add_column :mandates, :sif_bin_4_max30, :integer
    add_column :mandates, :sif_bin_5_max30, :integer
    add_column :mandates, :sif_bin_6_max30, :integer
    add_column :mandates, :sif_bin_7_max30, :integer
    add_column :mandates, :sif_bin_8_max30, :integer
    add_column :mandates, :sif_bin_9_max30, :integer
    add_column :mandates, :sif_bin_10_max30, :integer
    add_column :mandates, :sif_bin_11_max30, :integer
    add_column :mandates, :sif_bin_12_max30, :integer
    add_column :mandates, :sif_bin_13_max30, :integer
    add_column :mandates, :sif_bin_14_max30, :integer
    add_column :mandates, :sif_bin_15_max30, :integer
    add_column :mandates, :sif_bin_16_max30, :integer
    add_column :mandates, :sif_bin_17_max30, :integer
    add_column :mandates, :sif_bin_18_max30, :integer
    add_column :mandates, :sif_bin_19_max30, :integer
    add_column :mandates, :sif_bin_20_max30, :integer
    add_column :mandates, :sif_bin_21_max30, :integer
    add_column :mandates, :sif_bin_22_max30, :integer
    add_column :mandates, :sif_bin_23_max30, :integer
    add_column :mandates, :sif_bin_24_max30, :integer
    add_column :mandates, :sif_bin_25_max30, :integer
    add_column :mandates, :sif_bin_26_max30, :integer
    add_column :mandates, :sif_bin_27_max30, :integer
    add_column :mandates, :sif_bin_28_max30, :integer
  end
end
