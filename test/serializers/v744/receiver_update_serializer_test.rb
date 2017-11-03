require "test_helper"

class V744::ReceiverUpdateSerializerTest < ActiveSupport::TestCase
  test "should be fixed to only these parameters" do
    update = %i(client client_id client_name created_at has_active_alert id
             job job_id job_number rig_id rig_name run run_id run_number
             software_installation_id team_viewer_id team_viewer_password
             time time_stamp type updated_at well well_id well_name)
    receiver = %i(annular_pressure api atfa average_pulse average_quality
               ax ay az azm bat2 battery_number batv batw bit_depth
               block_height bore_pressure confidence_level dao
               decode_percentage delta_mtf dipa dipw dl_enabled dl_power
               formation_resistance frequency gama
               gamma_shock gamma_shock_axial_p gamma_shock_tran_p grav_roll
               gravity gravw gtfa gv0 gv1 gv2 gv3 gv4 gv5 gv6 gv7
               hole_depth hookload inc logging_sequence
               low_pulse_threshold mag_dec mag_roll magf magw mtfa
               mx my mz noise on_bottom power pulse_data pump_on_time
               pump_off_time pump_pressure pump_state pump_total_time
               pumps_on pumps_off reporter_version rop rotary_rpm
               s_n_ratio signal slips_out survey_md survey_sequence
               survey_tvd survey_vs sync_marker table temp temperature
               tempw tf tfo tool_face_data voltage weight_on_bit fft)
    fixed = Set.new(update + receiver)

    actual = create(:leam_receiver_update)
    json = V744::ReceiverUpdateSerializer.new(actual, root: false).as_json
    keys = Set.new(json.keys)

    assert_equal fixed, keys, "Missing #{(fixed ^ keys).to_a}"
  end
end
