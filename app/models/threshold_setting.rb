class ThresholdSetting < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :min_confidence_level, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, allow_blank: true
  validates :pump_off_time_in_milliseconds, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :max_temperature, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :min_batv, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :max_batv, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :pump_off_time_in_milliseconds, numericality: true, allow_blank: true

  def violations(hash)
    result = []

    if hash["confidence_level"] && min_confidence_level
      result << ["Confidence Level"] if hash["confidence_level"] > min_confidence_level
    end

    if hash["pump_off_time"] && pump_off_time_in_milliseconds
      result << "Pump Off Time" if hash["pump_off_time"] > pump_off_time_in_milliseconds
    end

    if hash["temp"] && max_temperature
      result << "Temperature" if hash["temp"] > max_temperature
    end

    if hash["batv"] && min_batv
      result << "Minimum Battery Voltage" if hash["batv"] < min_batv
    end

    if hash["batv"] && max_batv
      result << "Maximum Battery Voltage" if hash["batv"] > max_batv
    end

    if hash["batw"] && batw
      result << "Battery Warning" if hash["batw"] == "true"
    end

    if hash["dipw"] && dipw
      result << "Dip Angle Warning" if hash["dipw"] == "true"
    end

    if hash["gravw"] && gravw
      result << "Gravity Warning" if hash["gravw"] == "true"
    end

    if hash["magw"] && magw
      result << "Magnetic Warning" if hash["gravw"] == "true"
    end

    if hash["tempw"] && tempw
      result << "Temperature Warning" if hash["tempw"] == "true"
    end

    result
  end

end