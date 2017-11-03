class PulserMandateSerializer < BaseMandateSerializer
  attributes :settings

  def settings
    hash = {}
    # combine :logging_params, :thresholds, :gv_configs with no hierachy
    h = %i(logging_params thresholds misc pulse flow_switch_thresholds flow_switch_weights vibs shock_params batt_params)
    .map { |field| self.send(field)}
    .select(&:present?)
    .flatten
    .inject(hash) {|h, fields| h.merge!(fields)}
    .reject{|k,v| v.blank? }

    versionize h
  end

  private
  
  def vibs
    fields_to_hash %i(vib_trip_hi vib_trip_lo vib_trip_hi_a vib_trip_lo_a)
  end

  def logging_params
    object.logging_params
  end

  def shock_params
    fields_to_hash object.class.shock_params
  end

  def batt_params
    fields_to_hash object.class.batt_params
  end

  def thresholds
    object.thresholds
  end

  def misc
    fields_to_hash [:version, :filters_std_dev]
  end

  def pulse
    return if object.version == 2
    fields_to_hash [:pulse_min, :pulse_max, :pulse_close_period, :pulse_close_duty, :pulse_hold_duty]
  end

  def flow_switch_thresholds
    return if object.version == 2
    fields_to_hash [:flow_switch_threshold_strongly_on_high, :flow_switch_threshold_strongly_on_analog, :flow_switch_threshold_strongly_on_digital,
      :flow_switch_threshold_weakly_on_high, :flow_switch_threshold_weakly_on_analog, :flow_switch_threshold_weakly_on_digital,
      :flow_switch_threshold_off_high, :flow_switch_threshold_off_analog, :flow_switch_threshold_off_digital]
  end

  def flow_switch_weights
    return if object.version == 2
    fields_to_hash [:flow_switch_weight_strongly_on_high, :flow_switch_weight_strongly_on_analog_and_digital,
      :flow_switch_weight_strongly_off_high, :flow_switch_weight_strongly_off_analog_and_digital,
      :flow_switch_weight_weakly_on_high, :flow_switch_weight_weakly_on_analog_and_digital,
      :flow_switch_weight_weakly_off_high, :flow_switch_weight_weakly_off_analog_and_digital]
  end

  def fields_to_hash(array_of_fields)
    result = {}
    array_of_fields.each do |field|
      result[field] = object.send(field)
    end
    result.reject{|k,v| v.blank? }
  end

end
