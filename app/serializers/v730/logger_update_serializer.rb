class V730::LoggerUpdateSerializer < V730::UpdateSerializer
  attributes :block_height, :hookload, :bore_pressure, :annular_pressure, :pump_pressure, :bit_depth, :weight_on_bit, :rotary_rpm, :rop, :voltage, :inc,
             :azm, :api, :hole_depth, :gravity, :grav_roll, :mag_roll, :dipa, :survey_md, :survey_tvd, :survey_vs, :temperature, :com3, :com6,
             :pumps_on, :on_bottom, :livelog, :slips_out, :gama, :gamma_shock, :gamma_shock_axial_p, :gamma_shock_tran_p, :decode_percentage, :magf,
             :average_quality, :atfa, :gtfa, :mtfa, :delta_mtf, :formation_resistance,:mx,:my,:mz,:ax,:ay,:az,:batv,:batw,:dipw,:gravw,
             :reporter_version, :gv0, :gv1, :gv2, :gv3, :gv4, :gv5, :gv6, :gv7, :pumps_off

  def pumps_on
    object.pumps_on ? "Y" : "N"
  end

  def on_bottom
    object.on_bottom ? "Y" : "N"
  end

  def livelog
    "N"
  end

  def com3
    ""
  end

  def com6
    ""
  end

  def slips_out
    object.slips_out ? "Y" : "N"
  end

  def pumps_off
    object.last_hour? ? (object.pumps_on == false) : false
  end


end
