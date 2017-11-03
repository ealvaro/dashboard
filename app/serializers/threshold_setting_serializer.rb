class ThresholdSettingSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :pump_off_time_in_milliseconds, :max_temperature, :max_batv, :min_batv, :batw
  attributes :dipw, :gravw, :magw, :tempw, :min_confidence_level
  attributes :errors
end
