require "test_helper"

class SensorInterfaceMandateTest < ActiveSupport::TestCase
  test "still creates a token" do
    m = SensorInterfaceMandate.new
    m.save(validate: false)
    assert m.public_token.present?
  end

  test "it should be able to set the ref temp" do
    sim = FactoryGirl.create(:sensor_interface_mandate, ref_temp: 123.4)
    assert_equal 123.4, sim.ref_temp
  end

  test "it should be able to set the timeouts" do
    fields = {
      logging_period_in_secs: 5.1,
      max_survey_time_in_secs: 5.2,
      diaa_timeout_in_mins: 6,
      flow_inv_timeout_in_ms: 18000,
      thirteen_v_timeout_in_ms: 19000
    }

    sim = FactoryGirl.create(:sensor_interface_mandate, fields)

    assert_fields sim, fields
  end

  test "it should be able to set the delta fequencies" do
    fields = {
      delta_freq: 4,
      delta_threshold: 20.0
    }

    sim = FactoryGirl.create(:sensor_interface_mandate, fields)

    assert_fields sim, fields
  end

  test "it should be able to set the shock threshold" do
    fields = {
      shock_threshold: 32.10
    }

    sim = FactoryGirl.create(:sensor_interface_mandate, fields)

    assert_fields sim, fields
  end

  test "it should be able to set the max temp flow" do
    fields = {
      max_temp_flow: true
    }

    sim = FactoryGirl.create(:sensor_interface_mandate, fields)

    assert_fields sim, fields
  end

  test "it should be able to set the bat thresholds" do
    fields = {
      bat_hi_thresh:24.44,
      bat_lo_thresh:20.98,
      bat_switch_in_secs: 3600.01,
      bat_filter_coeff: 0.0011
    }

    sim = FactoryGirl.create(:sensor_interface_mandate, fields)

    assert_fields sim, fields
  end

  test "it should be able to set real time CAN" do
    fields = {
      real_time_can: true
    }

    sim = FactoryGirl.create(:sensor_interface_mandate, fields)

    assert_fields sim, fields
  end

  test "it should be able to set power off values" do
    fields = {
      power_off_timeout: 123,
      power_off_max_temp: 130.3
    }

    sim = FactoryGirl.create(:sensor_interface_mandate, fields)

    assert_fields sim, fields
  end

  test "it should respond to tool type klass" do
    assert_equal "SensorInterface", SensorInterfaceMandate.new.tool_type_klass
  end

  def assert_fields(object, fields)
    fields.each do |k,v|
      assert_equal v, object.reload.send(k)
    end
  end
end
