require 'type_conversion'

class AllPresentValidator < ActiveModel::Validator
  def validate(record)
    missing = options[:fields].select { |field| record.send(field).nil? }
    missing.each do |field|
      record.errors.add(field.to_sym, "must be filled in")
    end
  end
end

class AllOrNonePresentValidator < AllPresentValidator
  def validate(record)
    if options[:fields].any? { |field| !record.send(field).nil? }
      super(record)
    end
  end
end

class AllPresentIfConditionValidator < AllPresentValidator
  include TypeConversion

  def validate(record)
    value = record.send(options[:condition])
    if value_to_boolean(value)
      super(record)
    end
  end
end

class AnySelectedOrAnyPresentIfConditionValidator < ActiveModel::Validator
  include TypeConversion

  def validate(record)
    value = record.send(options[:condition])
    if value_to_boolean(value)

      any_selected = options[:selected].any? do |field|
        value = record.send(field)
        value_to_boolean(value)
      end

      any_present = options[:present].any? do |field|
        record.send(field).present?
      end

      unless any_selected || any_present
        output = options[:error_description] || "Select an option"
        record.errors[:base] << output
      end
    end
  end
end
