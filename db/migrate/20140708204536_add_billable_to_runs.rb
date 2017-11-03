class AddBillableToRuns < ActiveRecord::Migration
  def change
    add_column :runs, "max_temperature_as_billed", :integer
    add_column :runs, "item_start_hrs_as_billed",       :float
    add_column :runs, "circulating_hrs_as_billed",       :float
    add_column :runs, "rotating_hours_as_billed",      :float
    add_column :runs, "sliding_hours_as_billed",       :float
    add_column :runs, "total_drilling_hours_as_billed", :float
    add_column :runs, "mud_weight_as_billed",          :float
    add_column :runs, "gpm_as_billed",                 :integer
    add_column :runs, "bit_type_as_billed",            :string
    add_column :runs, "motor_bend_as_billed",          :float
    add_column :runs, "rpm_as_billed",                 :integer
    add_column :runs, "chlorides_as_billed",           :integer
    add_column :runs, "sand_as_billed",                :float
    add_column :runs, "brt_as_billed",                 :date
    add_column :runs, "art_as_billed",                 :date
    add_column :runs, "bha_as_billed",                  :integer
    add_column :runs, "agitator_distance_as_billed", :float
    add_column :runs, "mud_type_as_billed",            :string
    add_column :runs, "agitator_as_billed",            :string
  end
end
