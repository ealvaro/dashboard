require "#{Rails.root}/app/validators/logical.rb"

class PulserMandate < Mandate
  validates :batt_hi_thresh, numericality: {greater_than: 0}, allow_blank: true
  validates :batt_lo_thresh, numericality: {greater_than: 0}, allow_blank: true

  validates_inclusion_of :vib_trip_hi, in: 10..300, allow_blank: true, message: "Must be between 10 and 300"
  validates_inclusion_of :vib_trip_lo, in: 1..50, allow_blank: true, message: "Must be between 1 and 50"
  validates_inclusion_of :vib_trip_hi_a, in: 50..500, allow_blank: true, message: "Must be between 50 and 500"
  validates_inclusion_of :vib_trip_lo_a, in: 1..250, allow_blank: true, message: "Must be between 1 and 250"
  validates_presence_of :version, allow_blank: false

  def self.flow_switch_threshold_params
    %i(flow_switch_threshold_strongly_on_high flow_switch_threshold_strongly_on_analog flow_switch_threshold_strongly_on_digital
      flow_switch_threshold_weakly_on_high flow_switch_threshold_weakly_on_analog flow_switch_threshold_weakly_on_digital
      flow_switch_threshold_off_high flow_switch_threshold_off_analog flow_switch_threshold_off_digital)
  end

  def self.flow_switch_weight_params
    %i(flow_switch_weight_strongly_on_high flow_switch_weight_strongly_on_analog_and_digital
      flow_switch_weight_strongly_off_high flow_switch_weight_strongly_off_analog_and_digital
      flow_switch_weight_weakly_on_high flow_switch_weight_weakly_on_analog_and_digital
      flow_switch_weight_weakly_off_high flow_switch_weight_weakly_off_analog_and_digital)
  end

  validates_with AllOrNonePresentValidator, fields: flow_switch_threshold_params
  validates_with AllOrNonePresentValidator, fields: flow_switch_weight_params

  def self.valid_attributes
    Mandate.valid_attributes +
    %i(vib_trip_hi vib_trip_lo vib_trip_hi_a vib_trip_lo_a) + 
    %i(region_id version) + available_threshold_fields + 
    available_logging_params + pulse_params + filters_params + 
    shock_params + flow_switch_threshold_params + flow_switch_weight_params + batt_params
  end
  def self.pulse_params
    %i(pulse_min pulse_max pulse_close_period pulse_close_duty pulse_hold_duty)
  end

  def self.filters_params
    %i(filters_std_dev)
  end

  def self.shock_params
    %i(shock_radial shock_axial)
  end

  def self.batt_params
    %i(batt_hi_thresh batt_lo_thresh)
  end

  validate :batt_hi_thresh do |record|
    return unless [batt_hi_thresh, batt_lo_thresh].all?
    if batt_hi_thresh <= batt_lo_thresh
      record.errors.add :batt_hi_thresh, "Battery Hi must be greater than Battery Lo"
    end
  end

  validate :vib_trip_hi do |record|
    return unless [vib_trip_hi, vib_trip_lo].all?
    if vib_trip_hi <= vib_trip_lo
      record.errors.add :vib_trip_hi, "Vib Trip Hi must be greater than Vib Trip Lo"
    end
  end

  validate :vib_trip_hi_a do |record|
    return unless [vib_trip_hi_a, vib_trip_lo_a].all?
    if vib_trip_hi_a <= vib_trip_lo_a
      record.errors.add :vib_trip_hi_a, "Vib Trip Hi A must be greater than Vib Trip Lo A"
    end
  end

  def self.available_logging_params
    @@available_logging_params
  end

  @@available_logging_params= [ "Logging Interval" ]
    .map do |word|
      key = word.parameterize.gsub("-", "_")
      define_method(key) do
        logging_params && logging_params[key]
      end

      define_method("#{key}=") do |value|
        self.logging_params = (logging_params || {}).merge(key => value)
      end
      key
    end
  def self.available_threshold_fields
    @@available_threshold_fields
  end

  @@available_threshold_fields= ["Low Count Threshold",
    "High Count Threshold",
    "Shock Threshold",
    "Vibration Threshold",
    "Voltage Event Max",
    "Voltage Event Min",
    "Voltage Event Deta"
  ]
    .map do |word|
      key = word.parameterize.gsub("-", "_")
      define_method(key) do
        thresholds && thresholds[key]
      end

      define_method("#{key}=") do |value|
        self.thresholds = (thresholds || {}).merge(key => value)
      end
      key
    end

  def tool_type_klass
    "PulserDriver"
  end

  def apply_unique_params(params)
  end
end
