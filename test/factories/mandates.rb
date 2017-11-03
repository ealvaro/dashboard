FactoryGirl.define do
  factory :mandate do
    type "DualGammaMandate"
    sequence( :public_token ) {|n| n.to_s }
    expiration nil
    occurences -1
    for_tool_ids "*"
    priority nil
    vib_trip_hi nil
    vib_trip_lo nil
    vib_trip_hi_a nil
    vib_trip_lo_a nil
    contexts ["Admin"]
    gv_configs {}
    thresholds {}
    logging_params {}
    version nil
    pulse_min nil
    pulse_max nil
    pulse_close_period nil
    pulse_close_duty nil
    pulse_hold_duty nil
    flow_switch_threshold_strongly_on_high nil
    flow_switch_threshold_strongly_on_analog nil
    flow_switch_threshold_strongly_on_digital nil
    flow_switch_threshold_weakly_on_high nil
    flow_switch_threshold_weakly_on_analog nil
    flow_switch_threshold_weakly_on_digital nil
    flow_switch_threshold_off_high nil
    flow_switch_threshold_off_analog nil
    flow_switch_threshold_off_digital nil
    flow_switch_weight_strongly_on_high nil
    flow_switch_weight_strongly_on_analog_and_digital nil
    flow_switch_weight_strongly_off_high nil
    flow_switch_weight_strongly_off_analog_and_digital nil
    flow_switch_weight_weakly_on_high nil
    flow_switch_weight_weakly_on_analog_and_digital nil
    flow_switch_weight_weakly_off_high nil
    flow_switch_weight_weakly_off_analog_and_digital nil
    filters_std_dev nil
    string nil
    optional nil
    differential_diversion_threshold nil
    differential_diversion_threshold_high nil
    high_or_low_threshold_percentage nil
    high_timeout nil
    low_timeout nil
    requalification_timeout nil
    diversion_crossing_threshold nil
    diversion_integration_period nil
    diversion_window nil
    kstd nil
    kskew nil
    kkurt nil
    sample_period nil
  end

  factory :dual_gamma_mandate, parent: :mandate, class: DualGammaMandate do
    type "DualGammaMandate"
  end

  factory :sensor_interface_mandate, parent: :mandate, class: SensorInterfaceMandate do
    type "SensorInterfaceMandate"
  end

  factory :dual_gamma_lite_mandate, parent: :mandate, class: DualGammaLiteMandate do
    type "DualGammaLiteMandate"
  end
end
