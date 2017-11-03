require "test_helper"

class V710::EventsControllerTest < ActionController::TestCase
  test "missing headers get 401" do
    post :create, {}
    assert_response 401
  end

  test "wrong headers get 401" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = bad_token
      post :create, {}
      assert_response 401
    end
  end

  test "should be able to record smart battery attributes" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/events/sample_smart_battery.json")
    sb_tt = create(:smart_battery_tool_type)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      Tool.create!(uid: "04d68abd", tool_type_id: sb_tt.id)
      post :create, sample_json, "CONTENT_TYPE" => 'application/json'
      sb_event = Event.last
      assert_equal "Memory - Download", sb_event.event_type
      assert_equal "this-is-the-can-id", sb_event.can_id
      assert_equal "v1.2", sb_event.hardware_version
      assert_equal "0.1.0", sb_event.board_firmware_version
      configs = sb_event.configs
      intended_configs = {
        "battery_voltage" => "12.6",
        "temperature" => "300.3",
        "pulse_count" => "123",
        "circulating_hours" => "12.2",
        "non_circulating_hours" => "40",
        "amp_hour_expended" => "12.5" }
      assert_equal intended_configs, configs
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end
end
