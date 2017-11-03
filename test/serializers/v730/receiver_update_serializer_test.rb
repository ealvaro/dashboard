require "test_helper"

class V730::ReceiverUpdateSerializerTest < ActiveSupport::TestCase
  test "should be fixed to only these parameters" do
    update = %i(client client_id client_name created_at has_active_alert id
             job job_id job_number rig_id rig_name run run_id run_number
             software_installation_id team_viewer_id team_viewer_password
             time time_stamp type updated_at well well_id well_name)
    receiver = %i(annular_pressure api atfa average_pulse average_quality
               ax ay az azm bat2 battery_number batv batw bit_depth
               block_height bore_pressure com3 com6 confidence_level dao
               decode_percentage delta_mtf dipa dipw dl_enabled dl_power
               fft formation_resistance frequency gama
               gamma_shock gamma_shock_axial_p gamma_shock_tran_p grav_roll
               gravity gravw gtfa gv0 gv1 gv2 gv3 gv4 gv5 gv6 gv7
               hole_depth hookload inc livelog logging_sequence
               low_pulse_threshold mag_dec mag_roll magf magw mtfa
               mx my mz noise on_bottom power pulse_data pump_on_time
               pump_off_time pump_pressure pump_state pump_total_time
               pumps_on pumps_off reporter_version rop rotary_rpm
               s_n_ratio signal slips_out survey_md survey_sequence
               survey_tvd survey_vs sync_marker table temp temperature
               tempw tf tfo tool_face_data voltage weight_on_bit)
    fixed = Set.new(update + receiver)

    actual = create(:leam_receiver_update)
    json = V730::ReceiverUpdateSerializer.new(actual, root: false).as_json
    keys = Set.new(json.keys)

    assert_equal fixed, keys, "Missing #{(fixed ^ keys).to_a}"
  end

  test "should pass the low pulse threshold in the pulse chart" do
    FactoryGirl.create(:job, name: "OK-123456")
    receiver_update = FactoryGirl.create(:btr_receiver_update, low_pulse_threshold: 123, job_number: "OK-123456", run_number: 1, pulse_data: [ { time_stamp: (123 * 1000).to_i, value: (rand(4000) / 100.0) - 20, }, { time_stamp: (122 * 1000).to_i, value: (rand(4000) / 100.0) - 20, }, { time_stamp: (121 * 1000).to_i, value: (rand(4000) / 100.0) - 20, } ])

    json = V730::ReceiverUpdateSerializer.new(receiver_update, root: false).as_json

    assert_equal 123, json[:low_pulse_threshold]
  end

  test "should pass the job" do
    actual = create(:leam_receiver_update, job_number: "AB-010233")

    json = V730::ReceiverUpdateSerializer.new(actual, root: false).as_json

    assert_equal "AB-010233", json[:job]
  end

  test "should pass run_number as run" do
    actual = create(:leam_receiver_update, run_number: "133")

    json = V730::ReceiverUpdateSerializer.new(actual, root: false).as_json

    assert_equal "133", json[:run]
  end

  test "should pass client_name as client" do
    actual = create(:leam_receiver_update, client_name: "pioneer")

    json = V730::ReceiverUpdateSerializer.new(actual, root: false).as_json

    assert_equal "pioneer", json[:client]
  end

  test "should pass well_name as well" do
    actual = create(:leam_receiver_update, well_name: "rancho")

    json = V730::ReceiverUpdateSerializer.new(actual, root: false).as_json

    assert_equal "rancho", json[:well]
  end

  test "should pass time as time_stamp" do
    actual = create(:leam_receiver_update, time: "2015-12-21T15:46:55Z")

    json = V730::ReceiverUpdateSerializer.new(actual, root: false).as_json

    assert_equal "2015-12-21T15:46:55Z".to_datetime, json[:time_stamp]
  end

  test "should pass temperature as temp" do
    actual = create(:leam_receiver_update, temperature: 123)

    json = V730::ReceiverUpdateSerializer.new(actual, root: false).as_json

    assert_equal 123, json[:temp]
  end
end
