module Notifiers::Configurable
  extend ActiveSupport::Concern

  module ClassMethods
    def allowed_operators
      %w(== != < > include? exclude?)
    end

    def black_list
      %w(id type created_at updated_at pulse_data table tool_face_data job_id run_id client_id rig_id well_id)
    end

    def meta_list
      %w(last_update)
    end

    def not_logger
      %w(voltage dao reporter_version decode_percentage pump_on_time pump_off_time pump_total_time magf atfa gtfa mtfa delta_mtf formation_resistance mx my mz ax ay az batv batw dipw gravw gv0 gv1 gv2 gv3 gv4 gv5 gv6 gv7 magw tempw sync_marker survey_sequence logging_sequence confidence_level average_quality pump_state tf tfo bat2 low_pulse_threshold power dl_power frequency battery_number dl_enabled signal noise s_n_ratio mag_dec)
    end

    def not_rx
      %w(block_height hookload bit_depth weight_on_bit rotary_rpm rop voltage api hole_depth survey_md survey_tvd survey_vs pumps_on on_bottom slips_out pump_pressure)
    end

    def config_from_string(string)
      boolean = 'and'
      if string.include?(' and ') || string.include?(' or ')
        boolean = (string.include?(' and ') && 'and') || 'or'
        c0, c1 = string.split(boolean)
        conditions = [condition_from_string(c0), condition_from_string(c1)]
      else
        conditions = [condition_from_string(string)]
      end
      {
        "type"=>"grouping",
        "boolean"=>boolean,
        "conditions"=>conditions
      }
    end

    def condition_from_string(string)
      condition = {}
      if string.present?
        tokens = %w(update field operator value valueOp)
        tokens.each_with_index { |t, i| condition[t] = string.split.try(:[], i) || "" }

        if self.millisecond_fields.include?(condition["field"])
          condition["textValue"] = self.humanize_millis(condition["value"])
        end
      end
      condition.merge({"type"=>"condition"})
    end

    def field_value(field_name, update)
      last_update = field_name == "last_update"
      field_name = "created_at" if last_update

      value = update.try(field_name)

      if value.present?
        if number_like_fields.include? field_name
          value = value.to_f
        elsif string_fields.include? field_name
          value.downcase!
        elsif last_update
          # convert to milliseconds
          value = ((DateTime.now - value.to_datetime) * 24 * 60 * 60 * 1000).to_i
        end
      end

      value
    end

    def make_value(value, value_op, field_name)
      if field_name == "temperature" && value_op == "C"
        value = (value.to_f * (9.0 / 5.0)) + 32
      elsif field_name == "sync_marker" && value == "blank"
        value = ""
      elsif bool_fields.include? field_name
        value = string_to_boolean(value)
      elsif string_fields.include? field_name
        value.downcase!
      else
        value = value.delete(",").to_f
      end

      value
    end
  end
end
