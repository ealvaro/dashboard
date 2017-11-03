require "#{Rails.root}/app/validators/logical.rb"

class DualGammaMandate < Mandate
  validates :differential_diversion_threshold, allow_nil: true, numericality: { greater_than_or_equal_to: 0.5, less_than_or_equal_to: 20 }
  validates :differential_diversion_threshold_high, allow_nil: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 20 }
  validates :high_or_low_threshold_percentage, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :high_timeout, allow_nil: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 30 }
  validates :low_timeout, allow_nil: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 30 }
  validates :requalification_timeout, allow_nil: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 120 }
  validates :diversion_crossing_threshold, allow_nil: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :diversion_integration_period, allow_nil: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 60 }
  validates :diversion_window, allow_nil: true, numericality: { greater_than_or_equal_to: 10, less_than_or_equal_to: 50 }
  validates :kstd, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :kskew, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :kkurt, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :sample_period, allow_nil: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 120 }
  validates :power_off_timeout, allow_nil: true, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 240 }
  validates :power_off_max_temp, allow_nil: true, numericality: { greater_than_or_equal_to: 110, less_than_or_equal_to: 212 }
  validates :sif_threshold, allow_nil: true, numericality: { greater_than_or_equal_to: 15, less_than_or_equal_to: 120 }
  validates :qbus_sleep_time, allow_nil: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 60 }

  belongs_to :region

  def tool_type_klass
    "DualGamma"
  end

  def build_gv_configs
    (0..7).map do |index|
      config = gv_configs.find{|c| c["value"] == index.to_s}
      key = config.nil? ? nil : config["key"]
      GVConfig.new(key, index)
    end
  end

  def self.valid_attributes
    %i(version gv_configs) + available_gamma_power_settings + available_threshold_fields +
    available_logging_params + pulse_params + filters_params + Mandate.valid_attributes +
    available_health_params + available_alg_and_qbus_fields + available_sif_settings_params + available_sif_bin_params
  end

  def self.pulse_params
    %i(pulse_min pulse_max pulse_close_period pulse_close_duty pulse_hold_duty)
  end

  def self.filters_params
    %i(filters_std_dev)
  end


  def apply_unique_params(params)
    self.gv_configs=params[:gv_configs]
  end

  def gv_configs=(configs)
    if configs.present?
      self["gv_configs"] = configs.select{|k,hash| !hash["key"].blank?}.map{|k, hash| { key: hash["key"], value: k }}
    end
  end

  def gv_configs
    @gc_configs ||= (self["gv_configs"] || []).map{|h| ActiveSupport::HashWithIndifferentAccess.new(h) }
  end

  def available_gv_fields
    ["Gamma 1 Counts",
      "Gamma 2 Counts",
      "Average Gamma Counts",
      "Shock Intenisty Factor",
      "Status Word",
      "Lateral Vibration",
      "Axial Vibration",
      "Lateral Shock",
      "Axial Shock",
      "Combined Vibration",
    ]
  end

  def alg_and_qbus_fields
    Hash[self.class.available_alg_and_qbus_fields.collect{ |attr| [attr, self.send(attr)]}]
  end

  def self.available_alg_and_qbus_fields
    %w(
    tolteq_survey
    gamma_np
    qbus_sleep_time
    )
  end

  def gamma_power_settings
    Hash[self.class.available_gamma_power_settings.collect{ |attr| [attr, self.send(attr)]}]
  end

  def self.available_gamma_power_settings
    %w(
    power_off_timeout
    power_off_max_temp
    )
  end

  def self.available_sif_settings_params
    %i(sif_threshold)
  end

  def self.available_sif_bin_params
    available_sif_bin_max5_params + available_sif_bin_max30_params
  end

  def self.available_sif_bin_max5_params
    %i( sif_bin_0_max5 sif_bin_1_max5 sif_bin_2_max5 sif_bin_3_max5 )
  end

  def self.available_sif_bin_max30_params
    %i( sif_bin_0_max30 sif_bin_1_max30 sif_bin_2_max30 sif_bin_3_max30 sif_bin_4_max30 sif_bin_5_max30 sif_bin_6_max30
        sif_bin_7_max30 sif_bin_8_max30 sif_bin_9_max30 sif_bin_10_max30 sif_bin_11_max30 sif_bin_12_max30 sif_bin_13_max30
        sif_bin_14_max30 sif_bin_15_max30 sif_bin_16_max30 sif_bin_17_max30 sif_bin_18_max30 sif_bin_19_max30 sif_bin_20_max30
        sif_bin_21_max30 sif_bin_22_max30 sif_bin_23_max30 sif_bin_24_max30 sif_bin_25_max30 sif_bin_26_max30 sif_bin_27_max30
        sif_bin_28_max30
    )
  end

  validates_with AllOrNonePresentValidator, fields: available_sif_bin_max5_params
  validates_with AllOrNonePresentValidator, fields: available_sif_bin_max30_params

  validate :positive_bins
  validate :cascading_bins_max5
  validate :cascading_bins_max30

  def positive_bins
    #cleaner than numericality validations for all params
    (self.class.available_sif_bin_max30_params + self.class.available_sif_bin_max5_params).each do |attr|
      tmp = send(attr)
      if tmp.present? && tmp <= 0
        errors.add(attr, "has to be greater than 0")
      end
    end
  end

  def cascading_bins_max5
    if (tmp = [sif_bin_0_max5, sif_bin_1_max5, sif_bin_2_max5, sif_bin_3_max5]).any?
      tmp.each_with_index do |obj, index|
        next if index == 0 || tmp[index - 1].blank? || tmp[index].blank?
        if tmp[index] <= tmp[index - 1]
          errors.add("sif_bin_#{index}_max5".to_sym, "has to be greater than bin #{index - 1}")
        end
      end
    end
  end

  def cascading_bins_max30
    if (tmp = [
      sif_bin_0_max30, sif_bin_1_max30, sif_bin_2_max30, sif_bin_3_max30, sif_bin_4_max30, sif_bin_5_max30, sif_bin_6_max30, sif_bin_7_max30, sif_bin_8_max30, sif_bin_9_max30,
      sif_bin_10_max30, sif_bin_11_max30, sif_bin_12_max30, sif_bin_13_max30, sif_bin_14_max30, sif_bin_15_max30, sif_bin_16_max30, sif_bin_17_max30, sif_bin_18_max30, sif_bin_19_max30,
      sif_bin_20_max30, sif_bin_21_max30, sif_bin_22_max30, sif_bin_23_max30, sif_bin_24_max30, sif_bin_25_max30, sif_bin_26_max30, sif_bin_27_max30, sif_bin_28_max30
    ]).any?
      tmp.each_with_index do |obj, index|
        next if index == 0 || tmp[index - 1].blank? || tmp[index].blank?
        if tmp[index] <= tmp[index - 1]
          errors.add("sif_bin_#{index}_max30".to_sym, "has to be greater than bin #{index - 1}")
        end
      end
    end
  end

  def sif_bin_params
    Hash[self.class.available_sif_bin_params.collect{|attr| [attr, self.send( attr )]}]
  end

  def sif_settings_params
    Hash[self.class.available_sif_settings_params.collect{|attr| [attr, self.send( attr )]}]
  end

  def health_params
    Hash[self.class.available_health_params.collect{ |attr| [ attr, self.send( attr ) ] }]
  end

  def self.available_health_params
  %w( differential_diversion_threshold
      differential_diversion_threshold_high
      diversion_integration_period
      diversion_window
      diversion_crossing_threshold
      sample_period
      high_timeout
      low_timeout
      high_or_low_threshold_percentage
      kstd
      kskew
      kkurt
      health_algorithm
      requalification_timeout)
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

  def self.available_logging_params
    @@available_logging_params
  end

  @@available_logging_params= ["Running Average Window",
    "Logging Interval",
    "Idle Logging Interval",
    "Logging Timeout"
  ]
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

  class GVConfig < Struct.new(:key, :value); end

end
