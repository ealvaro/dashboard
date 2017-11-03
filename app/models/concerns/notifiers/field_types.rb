module Notifiers::FieldTypes
  extend ActiveSupport::Concern

  module ClassMethods
    def bool_fields
      %w(pumps_on on_bottom slips_out batw dipw gravw magw tempw dl_enabled)
    end

    def string_fields
      %w(job_number run_number rig_name well_name client_name team_viewer_id team_viewer_password pump_state reporter_version sync_marker type)
    end

    def number_like_fields
      %w(survey_md decode_percentage average_quality bit_depth hole_depth power dl_power frequency battery_number signal noise s_n_ratio mag_dec)
    end

    # see also frontend millisecond_fields
    def millisecond_fields
      %w(pump_on_time pump_off_time pump_total_time last_update)
    end
  end
end
