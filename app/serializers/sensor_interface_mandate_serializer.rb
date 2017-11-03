class SensorInterfaceMandateSerializer < BaseMandateSerializer
  attributes :ref_temp, :logging_period_in_secs, :max_survey_time_in_secs, :diaa_timeout_in_mins, :flow_inv_timeout_in_ms,
             :thirteen_v_timeout_in_ms, :delta_freq, :delta_threshold, :shock_threshold, :max_temp_flow, :bat_hi_thresh,
             :bat_lo_thresh, :bat_switch_in_secs, :bat_filter_coeff, :real_time_can, :power_off_timeout, :power_off_max_temp
end
