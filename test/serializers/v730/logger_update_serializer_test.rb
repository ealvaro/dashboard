require "test_helper"

class V730::LoggerUpdateSerializerTest < ActiveSupport::TestCase
  test "should be fixed to only these parameters" do
    update = %i(client client_id client_name created_at has_active_alert id
             job job_id job_number rig_id rig_name run run_id run_number
             software_installation_id team_viewer_id team_viewer_password
             time time_stamp type updated_at well well_id well_name)
    logger = %i(annular_pressure api atfa average_quality ax ay az azm
             batv batw bit_depth block_height bore_pressure com3 com6
             decode_percentage delta_mtf dipa dipw formation_resistance
             gama gamma_shock gamma_shock_axial_p gamma_shock_tran_p
             grav_roll gravity gravw gtfa gv0 gv1 gv2 gv3 gv4 gv5 gv6 gv7
             hole_depth hookload inc livelog mag_roll magf mtfa mx my mz
             on_bottom pump_pressure pumps_off pumps_on reporter_version
             rop rotary_rpm slips_out survey_md survey_tvd survey_vs
             temperature voltage weight_on_bit)
    fixed = Set.new(update + logger)

    actual = create(:leam_receiver_update)
    json = V730::LoggerUpdateSerializer.new(actual, root: false).as_json
    keys = Set.new(json.keys)

    assert_equal fixed, keys, "Missing #{(fixed ^ keys).to_a}"
  end
end
