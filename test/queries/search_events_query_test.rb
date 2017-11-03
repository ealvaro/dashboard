require "test_helper"

class SearchEventsQueryTest < ActiveSupport::TestCase

  def setup
    @tool_type = ToolType.create!(name: "Test Tool Type")
    @tool = @tool_type.tools.create!
    20.times do
      @tool.events.create!(
        event_type: "Some Event",
        time: Time.now,
        reporter_type: "Reporter Type",
        board_firmware_version: "1.0.0",
        board_serial_number: "1234",
        primary_asset_number: 101
      )
    end
    20.times do
      @tool.events.create!(
        event_type: "Memory",
        time: Time.now,
        reporter_type: "Reporter Type",
        board_firmware_version: "1.0.0",
        board_serial_number: "1234",
        primary_asset_number: 101
      )
    end
  end

  test "will return 30 events per page" do
    events = SearchEventsQuery.new(@tool).find
    assert_equal 30, events.count
  end

  test "will return 10 events for page 2" do
    events = SearchEventsQuery.new(@tool, page: 2).find
    assert_equal 10, events.count
  end

  test "will filter by event type" do
    events = SearchEventsQuery.new(@tool, event_types: ["Memory"]).find
    assert_equal 20, events.count
  end

  test "will return zero if no event types provided" do
    events = SearchEventsQuery.new(@tool, event_types: []).find
    assert_equal 0, events.count
  end

end
