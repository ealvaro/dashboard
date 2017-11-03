Erdos.filter('humanize', () ->
  (string) ->
    switch string
      when 'RequestCorrection'
        return 'Request Correction'
      when 'CorrectedNotification'
        return 'Corrected Notification'
      when 'ThresholdNotification'
        return 'Threshold Notification'
      when 'RequestSurveyApproval'
        return 'Request Survey Approval'
      when 'health_algorithm'
        return "Health Algorithm"
      when 'no_pulse'
        return 'No Pulse'
      when 'tolteq_survey_mode'
        return 'Tolteq Survey Mode'
      when 'power_off_timeout'
        return 'Power Off Timeout'
      when 'power_off_max_temp'
        return 'Power Off Max Temperature'
      when 'downhole_api_val'
        return "Downhole API Val"
      when 'min_threshold'
        return "Min Threshold"
      when 'idle_logging_interval'
        return "Idle Logging Interval"
      when 'sample_period'
        return "Sample Period"
      when 'max_threshold'
        return "Max Threshold"
      when 'vibration_threshold'
        return "Vibration Threshold"
      when 'k_skew'
        return "K Skew"
      when 'voltage_event_max'
        return "Voltage Event Max"
      when 'high_low_percentage'
        return "High Low Percentage"
      when 'uphole_api_val'
        return "Uphole API Val"
      when 'low_timeout'
        return "Low Timeout"
      when 'voltage_event_delta'
        return "Voltage Event Delta"
      when 'diff_diversion'
        return "Diff Diversion"
      when 'diff_diversion_high'
        return "Diff Diversion High"
      when 'k_kurt'
        return "K Kurt"
      when 'logging_timeout'
        return "Logging Timeout"
      when 'running_avg_window'
        return "Running Avg Window"
      when 'shock_threshold'
        return "Shock Threshold"
      when 'div_crossing_thresh'
        return "Div Crossing Thresh"
      when 'voltage_event_min'
        return "Voltage Event Min"
      when 'qbus_sleep_time'
        return "Qbus Sleep Time"
      when 'logging_interval'
        return "Logging Interval"
      when 'high_timeout'
        return "High Timeout"
      when 'k_std'
        return "K STD"
      when 'requalification_time'
        return "Requalification Time"
      when 'diversion_integral'
        return "Diversion Integral"
      when 'diversion_window'
        return "Diversion Window"
      when 'accel_thresh_ad_off'
        return "Accel Thresh AD Off"
      when 'accel_thresh_ad_strongly_on'
        return "Accel Thresh AD Strongly On"
      when 'accel_thresh_ad_weakly_on'
        return "Accel Thresh AD Weakly On"
      when 'accel_thresh_dd_off'
        return "Accel Thresh DD Off"
      when 'accel_thresh_dd_strongly_on'
        return "Accel Thresh DD Strongly On"
      when 'accel_thresh_dd_weakly_on'
        return "Accel Thresh DD Weakly On"
      when 'accel_thresh_hg_off'
        return "Accel Thresh HG Off"
      when 'accel_thresh_hg_strongly_on'
        return "Accel Thresh HG Strongly On"
      when 'accel_thresh_hg_weakly_on'
        return "Accel Thresh HG Weakly On"
      when 'battery_hi'
        return "Battery Hi"
      when 'battery_lo'
        return "Battery Lo"
      when 'logging_interval'
        return "Logging Interval"
      when 'pulse_close_duty'
        return "Pulse Close Duty"
      when 'pulse_close_period'
        return "Pulse Close Period"
      when 'pulse_hold_duty'
        return "Pulse Hold Duty"
      when 'pulse_max'
        return "Pulse Max"
      when 'pulse_min'
        return "Pulse Min"
      when 'shock_axial'
        return "Shock Axial"
      when 'shock_radial'
        return "Shock Radial"
      when 'st_dev_filter'
        return "St Dev Filter"
      when 'weights_ad_strongly_off'
        return "Weights AD Strongly Off"
      when 'weights_ad_strongly_on'
        return "Weights AD Strongly On"
      when 'weights_ad_weakly_off'
        return "Weights AD Weakly Off"
      when 'weights_ad_weakly_on'
        return "Weights AD Weakly On"
      when 'weights_hg_strongly_off'
        return "Weights HG Strongly Off"
      when 'weights_hg_strongly_on'
        return "Weights HG Strongly On"
      when 'weights_hg_weakly_off'
        return "Weights HG Weakly Off"
      when 'weights_hg_weakly_on'
        return "Weights HG Weakly On"
      when 'vib_trip_hi'
        return "Vib Trip Hi"
      when 'vib_trip_hi_a'
        return "Vib Trip Hi A"
      when 'vib_trip_lo'
        return "Vib Trip Lo"
      when 'vib_trip_lo_a'
        return "Vib Trip Lo A"
      when 'sif_threshold'
        return "SIF Threshold"
      when 'amp_hour_expended'
        return 'Amp Hour Expended'
      when 'circulating_hours'
        return 'Circulating Hours'
      when 'pulse_count'
        return 'Pulse Count'
      when 'battery_voltage'
        return 'Battery Voltage'
      when 'non_circulating_hours'
        return 'Non Circulating Hours'
      when 'temperature'
        return 'Temperature'


    if string.indexOf("sif_bin_") > -1
      return "SIF Bin " + string.replace("sif_bin_", "")
    string
)
