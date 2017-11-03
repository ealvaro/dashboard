class V744::ReceiverUpdateSerializer < V730::UpdateSerializer
  attributes :block_height, :hookload, :bore_pressure, :annular_pressure, :pump_pressure, :bit_depth, :weight_on_bit, :rotary_rpm, :rop, :voltage, :inc, :azm, :api,
             :hole_depth, :power, :dl_power, :battery_number, :frequency, :signal, :mag_dec, :s_n_ratio, :noise, :gravity, :grav_roll, :mag_roll, :dipa, :survey_md, :survey_tvd, :survey_vs, :temperature,
             :pumps_on, :on_bottom, :slips_out, :dao, :reporter_version, :decode_percentage, :pump_on_time, :pump_off_time,
             :pump_total_time, :magf, :gama, :gamma_shock, :gamma_shock_axial_p, :gamma_shock_tran_p, :atfa, :gtfa, :mtfa, :delta_mtf, :formation_resistance, :mx, :my, :mz, :ax, :ay, :az, :bat2, :batv, :batw, :dipw, :gravw,
             :gv0, :gv1, :gv2, :gv3, :gv4, :gv5, :gv6, :gv7, :magw, :dl_enabled, :tempw, :sync_marker, :survey_sequence, :logging_sequence,
             :confidence_level, :average_quality, :pump_state, :tf, :tfo, :pulse_data, :table, :tool_face_data, :temp, :low_pulse_threshold,
             :average_pulse, :pumps_off, :fft

  def pulse_data
    object.pulse_data || []
  end

  def temp
    object.temperature
  end

  def pumps_off
    object.last_hour? ? (object.pump_state.try(:downcase) == 'off') : false
  end
end
