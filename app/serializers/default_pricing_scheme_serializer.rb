class DefaultPricingSchemeSerializer < ActiveModel::Serializer
  attributes :max_temperature, :max_vibe, :max_shock, :shock_warnings, :motor_bend, :rpm, :agitator_distance, :mud_type
  attributes :dd_hours, :mwd_hours, :id, :customizable_attrs

  def customizable_attrs
    [:max_temperature, :max_vibe, :max_shock, :shock_warnings, :motor_bend, :rpm, :agitator_distance, :dd_hours, :mwd_hours]
  end
end
