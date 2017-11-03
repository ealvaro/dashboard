module Notifiers::HumanReadable
  extend ActiveSupport::Concern

  module ClassMethods

  attr_accessor :display_type


  def humanize_op(op)
      case op
        when "==" then "is equal to"
        when "!=" then "is not equal to"
        when "<" then "is less than"
        when ">" then "is greater than"
        when "include?" then "contains"
        when "exclude?" then "does not contain"
        else "Unable to humanize that operation"
      end
    end

    def humanize_update(update)
      case update
        when "LeamReceiverUpdate" then "LRx"
        when "BtrReceiverUpdate" then "BTR Monitor"
        when "BtrControlUpdate" then "BTR Control"
        when "LoggerUpdate" then "Logger"
        when "EmReceiverUpdate" then "APS EM"
        else "#{Update.human_attribute_name update}"
      end
    end

    def humanize_field(field)
      "#{Update.human_attribute_name field}"
    end

    def humanize_field_op_value(condition)
      field = condition['field']
      op = condition['operator']
      if UpdateNotifier.millisecond_fields.include?(field)
        value = condition['textValue']
      else
        value = condition['value']
      end

      "#{UpdateNotifier.humanize_field field} #{UpdateNotifier.humanize_op op} #{value}"
    end

    def humanize_millis(millis)
      milliseconds = millis.to_f
      if milliseconds >= 0
        hours = (milliseconds / (1000 * 60 * 60)).floor
        milliseconds -= (hours * 1000 * 60 * 60)

        minutes = (milliseconds / (60 * 1000)).floor
        milliseconds -= (minutes * 60 * 1000)

        seconds = (milliseconds / 1000).floor

        ("%02d" % [hours, 23].min) + (":%02d" % minutes) + (":%02d" % seconds)
      end
    end

    def string_from_condition(condition)
      if condition["type"] == 'grouping'

        clauses = condition["conditions"].map { |c| self.string_from_condition(c) }
        out = clauses.join(" #{condition['boolean'].downcase} ")
        out = "(#{out})" if clauses.length > 1
      else
        out = "#{self.humanize_update(condition['update'])}"
        out += " #{self.humanize_field_op_value(condition)}"
        out += " #{condition['valueOp']}" if condition['valueOp'].present?
      end
      out
    end
  end
  #end class methods

  def display_type
    case self.class
      when GlobalNotifier then "Global"
      when GroupNotifier then "Rig Group"
      when RigNotifier then "Rig"
      else "Undefined"
    end
  end


  def humanize_value(value, field)
    if UpdateNotifier.millisecond_fields.include?(field)
      UpdateNotifier.humanize_millis(value)
    elsif UpdateNotifier.number_like_fields.include?(field)
      value.to_i
    elsif UpdateNotifier.bool_fields.include?(field) || UpdateNotifier.string_fields.include?(field)
      value
    else
      value.to_f.round(2)
    end
  end

  def pretty_configuration
    clauses = configuration["conditions"].map { |c| UpdateNotifier.string_from_condition(c) }
    clauses.join(" #{configuration['boolean'].downcase} ")
  end

  def humanize_status(field, update)
    if field == "last_update"
      human_value = update.try("created_at").to_formatted_s(:db)
    else
      human_value = "#{humanize_value(update.try(field), field)}"
    end

    if human_value == "" then human_value = "blank" end

    "#{UpdateNotifier.humanize_update(update.type)} #{UpdateNotifier.humanize_field(field)}: #{human_value}"
  end

  def gather_status(conditions, updates)
    status = []

    conditions.each do |condition|
      if condition['type'].downcase == 'condition'
        update = updates[condition['update']]
        if update.present?
          status += [humanize_status(condition['field'], update)]
        end
      elsif condition['type'].downcase == 'grouping'
        status += gather_status(condition['conditions'], updates)
      end
    end
    status
  end

  def status_from_notifiable(updates)
    status = gather_status(configuration['conditions'], updates)
    if status.present?
      status.join(", ")
    else
      "Error: update(s) unavailable"
    end
  end
end
