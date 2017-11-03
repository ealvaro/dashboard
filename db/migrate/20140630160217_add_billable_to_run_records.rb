class AddBillableToRunRecords < ActiveRecord::Migration
  def change
    add_column  :run_records, "max_temperature_as_billed", :integer
    add_column :run_records, "item_start_hrs_as_billed",       :float
    add_column :run_records, "circulating_hrs_as_billed",       :float
    add_column :run_records, "rotating_hours_as_billed",      :float
    add_column :run_records, "sliding_hours_as_billed",       :float
    add_column :run_records, "total_drilling_hours_as_billed", :float
    add_column :run_records, "mud_weight_as_billed",          :float
    add_column :run_records, "gpm_as_billed",                 :integer
    add_column :run_records, "bit_type_as_billed",            :string
    add_column :run_records, "motor_bend_as_billed",          :float
    add_column :run_records, "rpm_as_billed",                 :integer
    add_column :run_records, "chlorides_as_billed",           :integer
    add_column :run_records, "sand_as_billed",                :float
    add_column :run_records, "brt_as_billed",                 :date
    add_column :run_records, "art_as_billed",                 :date
    add_column :run_records, "bha_as_billed",                  :integer
    add_column :run_records, "agitator_distance_as_billed", :float
    add_column :run_records, "mud_type_as_billed",            :string
    add_column :run_records, "agitator_as_billed",            :string
  end
end
