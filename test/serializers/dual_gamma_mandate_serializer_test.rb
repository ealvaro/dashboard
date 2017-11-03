require "test_helper"

class DualGammaMandateSerializerTest < ActiveSupport::TestCase
  test "should have a typo in the serializer" do
    json = DualGammaMandateSerializer.new(DualGammaMandate.new( voltage_event_deta: "123")).as_json
    assert_equal("123", json[:dual_gamma_mandate][:settings]["voltage_event_deta"])
  end

  test "should pass power off timeout in settings" do
    json = DualGammaMandateSerializer.new(DualGammaMandate.new( power_off_timeout: 123), root: false).as_json
    assert_equal 123, json[:settings]["power_off_timeout"]
  end

  test "should pass power off max temp in settings" do
    json = DualGammaMandateSerializer.new(DualGammaMandate.new( power_off_max_temp: 123), root: false).as_json
    assert_equal 123, json[:settings]["power_off_max_temp"]
  end

  test "should pass sif threshold in settings" do
    json = DualGammaMandateSerializer.new(DualGammaMandate.new( sif_threshold: 21.1), root: false).as_json
    assert_equal 21.1, json[:settings][:sif_threshold]
  end

  test "should specify a gv config as blank on demand" do
    mandate = DualGammaMandate.new(gv_configs: {"0" => {"key" => "Forced Empty"}})
    assert_equal( {"gv0" => ""}, DualGammaMandateSerializer.new(mandate, root:false).as_json[:settings] )
  end
end
