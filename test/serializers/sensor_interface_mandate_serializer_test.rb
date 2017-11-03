require "test_helper"

class SensorInterfaceMandateSerializerTest < ActiveSupport::TestCase
  test "it should set all basic attributes correctly" do
    fields = {
      ref_temp: 123.4,
      logging_period_in_secs: 5.1,
      max_survey_time_in_secs: 5.2,
      diaa_timeout_in_mins: 6,
      flow_inv_timeout_in_ms: 18000,
      thirteen_v_timeout_in_ms: 19000,
      delta_freq: 4,
      delta_threshold: 20.0,
      shock_threshold: 32.10,
      max_temp_flow: true,
      bat_hi_thresh:24.44,
      bat_lo_thresh:20.98,
      bat_switch_in_secs: 3600.01,
      bat_filter_coeff: 0.0011,
      real_time_can: true,
      power_off_timeout: 123,
      power_off_max_temp: 130.3
    }


    json = SensorInterfaceMandateSerializer.new(FactoryGirl.create(:sensor_interface_mandate, fields), root: false).as_json

    fields.each do |k,v|
      assert_equal v, json[k], "Failed to set #{k}"
    end
  end
end
