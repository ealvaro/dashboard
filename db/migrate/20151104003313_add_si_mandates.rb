class AddSiMandates < ActiveRecord::Migration
  def change
    {
      ref_temp: :float,
      logging_period_in_secs: :float,
      max_survey_time_in_secs: :float,
      diaa_timeout_in_mins: :integer,
      flow_inv_timeout_in_ms: :integer,
      thirteen_v_timeout_in_ms: :integer,
      delta_freq: :integer,
      delta_threshold: :float,
      shock_threshold: :float,
      max_temp_flow: :boolean,
      bat_hi_thresh: :float,
      bat_lo_thresh: :float,
      bat_switch_in_secs: :float,
      bat_filter_coeff: :float,
      real_time_can: :boolean
    }.each do |k,v|
      add_column :mandates, k, v
    end
  end
end
