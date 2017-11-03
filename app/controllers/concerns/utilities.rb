module Utilities
  def string_to_boolean(value)
    value = value.try(:downcase).try(:strip)

    return nil if value.blank?

    if ["good", "true", "y", "yes", "warn", "on"].include? value.try(:to_s).try(:downcase)
      true
    else
      false
    end
  end

  def strip_and_upcase(string)
    return nil if (string.blank? || string == "unknown")

    string.try(:strip).try(:upcase)
  end

  def value_to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
end
