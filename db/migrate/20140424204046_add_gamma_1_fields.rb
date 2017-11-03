class AddGamma1Fields < ActiveRecord::Migration
  def change
    change_table :mandates do |t|
      t.string :version
      
      t.integer :pulse_min
      t.integer :pulse_max
      t.integer :pulse_close_period
      t.integer :pulse_close_duty
      t.integer :pulse_hold_duty

      t.float :flow_switch_threshold_strongly_on_high
      t.float :flow_switch_threshold_strongly_on_analog
      t.float :flow_switch_threshold_strongly_on_digital

      t.float :flow_switch_threshold_weakly_on_high
      t.float :flow_switch_threshold_weakly_on_analog
      t.float :flow_switch_threshold_weakly_on_digital

      t.float :flow_switch_threshold_off_high
      t.float :flow_switch_threshold_off_analog
      t.float :flow_switch_threshold_off_digital

      t.integer :flow_switch_weight_strongly_on_high
      t.integer :flow_switch_weight_strongly_on_analog_and_digital

      t.integer :flow_switch_weight_strongly_off_high
      t.integer :flow_switch_weight_strongly_off_analog_and_digital

      t.integer :flow_switch_weight_weakly_on_high
      t.integer :flow_switch_weight_weakly_on_analog_and_digital

      t.integer :flow_switch_weight_weakly_off_high
      t.integer :flow_switch_weight_weakly_off_analog_and_digital

      t.string :filters_std_dev
    end

  end
end
