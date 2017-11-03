class SensorInterfaceMandate < Mandate
  def self.valid_attributes
    Mandate.valid_attributes + general_params + timeout_params + delta_frequency_params + shock_count_params +
      telemetry_params + battery_params + can_params
  end

  def self.general_params
    %i( ref_temp )
  end

  def self.timeout_params
    %i( logging_period_in_secs max_survey_time_in_secs diaa_timeout_in_mins flow_inv_timeout_in_ms thirteen_v_timeout_in_ms )
  end

  def self.delta_frequency_params
    %i( delta_freq delta_threshold )
  end

  def self.shock_count_params
    %i( shock_threshold )
  end

  def self.telemetry_params
    %i( max_temp_flow )
  end

  def self.battery_params
    %i( bat_hi_thresh bat_lo_thresh bat_switch_in_secs bat_filter_coeff )
  end

  def self.can_params
    %i( real_time_can  )
  end

  def tool_type_klass
    "SensorInterface"
  end

  def apply_unique_params(params)
  end
end
