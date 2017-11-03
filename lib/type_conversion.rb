module TypeConversion
  def string_to_boolean(value)
    value = value.try(:downcase).try(:strip)

    return nil if value.blank?

    %w(good true y yes on).include? value.try(:to_s).try(:downcase)
  end

  def strip_and_downcase(string)
    return nil if (string.blank? || string == "unknown")

    string.try(:strip).try(:downcase)
  end

  def value_to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
end
