require "test_helper"

class ToolTest < ActiveSupport::TestCase

  test "requires a tool_type" do
    m = Tool.new
    m.valid?
    assert_equal true, m.errors[:tool_type].any?
  end

  test "Tool creates a token" do
    m = Tool.new
    m.save
    assert m.uid.present?
  end

  test "token in 16 long" do
    m = Tool.new
    m.save
    assert 16, m.uid.length
  end

  test "Can find a Tool by uid" do
    Tool.delete_all
    m = create_tool uid: "foo"
    assert_equal m, Tool.for_uid("foo")
  end

  test "certain uid endings are invalid" do
    m = Tool.new

    assert_equal false, m.valid_uid?("abcd0000")
    assert_equal false, m.valid_uid?("abcd8000")
    assert_equal false, m.valid_uid?("abcdffff")
    assert_equal true, m.valid_uid?("abcdefff")
  end

  test "count is counted on tools" do
    tool = create_tool uid: "foo"
    2.times { tool.events.build.save(validate: false) }
    tool.reload
    assert_equal 2, tool.events_count
  end

  test "when a tool is deleted, so are it's events" do
    tool = create_tool uid: "foo"
    2.times { tool.events.build.save(validate: false) }
    tool.reload
    assert_equal 2, tool.events.count
    events_count = Event.count
    tool.destroy
    assert_equal events_count - 2, Event.count
  end

  test "tool uid must be unique" do
    tool1 = create(:tool)
    tool2 = build(:tool, uid: tool1.uid)
    assert !tool2.valid?
  end

  test "tool.merge should combine two tools" do
    tool = create(:tool)
    tool2 = create(:tool)
    tool_count = Tool.count
    tool.merge! tool2
    assert_equal tool_count - 1, Tool.count
  end

  test "tool.merge should have the earliest created at date" do
    created_at = 2.days.ago
    tool = create(:tool)
    tool2 = create(:tool, created_at: created_at)
    tool.merge! tool2
    assert_equal created_at, tool.created_at
  end

  test "tool.merge should merge the events" do
    tool = create(:tool)
    tool2 = create(:tool)
    create(:event, tool: tool2)
    tool.merge! tool2
    assert_equal 1, tool.events.count
  end

  test 'multiple run records for one run' do
    rr = create( :run_record )
    new_rr = create( :run_record, run: rr.run, tool: rr.tool )
    assert_equal( rr.tool.runs.size, 1 )
    assert_equal( rr.tool.run_records.size, 2 )
  end

  test 'self.destroy should destroy self.runs' do
    tool = create( :run_record ).tool
    create( :run_record, tool: tool )
    assert_equal( RunRecord.all.count, 2 )
    tool.destroy
    assert_equal( RunRecord.all.count, 0 )
  end

  test 'should not be valid with out a tool type' do
    tool = build(:tool, tool_type: nil)
    assert(!tool.valid?)
    tool.tool_type = ToolType.last
    assert(tool.valid?)
  end

  test 'should only update tool cache if the time attribute is newer or not specified' do
    tool = create(:tool)
    event = create(:event, tool: tool, time: DateTime.now)
    tool.touch
    assert_equal(event.time, tool.cache["time"])
    create(:event, tool: tool, time: event.time - 2.days)
    assert_equal(event.time, tool.cache["time"])
  end

  test 'should not replace hw or fw with a blank value in tool cache' do
    tool = create(:tool)
    event = create(:event, tool: tool, board_firmware_version: "5.3.4", hardware_version: "1.2.3")
    tool.touch
    assert_equal(event.board_firmware_version, tool.cache["board_firmware_version"])
    assert_equal(event.hardware_version, tool.cache["hardware_version"])
    event2 = create(:event, tool: tool, board_firmware_version: "", hardware_version: "")
    tool.touch
    assert_equal(event.board_firmware_version, tool.cache["board_firmware_version"])
    assert_equal(event.hardware_version, tool.cache["hardware_version"])
  end

  test 'should replace the hw and fw with valid value in tool cache' do
    tool = create(:tool)
    event = create(:event, tool: tool, board_firmware_version: "5.3.4", hardware_version: "1.2.3")
    tool.touch
    assert_equal(event.board_firmware_version, tool.cache["board_firmware_version"])
    assert_equal(event.hardware_version, tool.cache["hardware_version"])
    event2 = create(:event, tool: tool, board_firmware_version: "5.4.4", hardware_version: "1.2.2")
    tool.touch
    assert_equal(event2.board_firmware_version, tool.cache["board_firmware_version"])
    assert_equal(event2.hardware_version, tool.cache["hardware_version"])
  end

  # test 'can get correct lifetime_histograms' do
  #   tool = create :tool
  #   n = 3
  #   n.times { create(:histogram, tools: [tool], data: histogram_data) }
  #   assert_equal (histogram_data["temperature"]["0-10"] * n),
  #                 Tool.last.lifetime_histograms["Temperature"].first[:count]
  #   assert_equal (histogram_data["shock"]["pd_axial"]["0-10"] * n),
  #                 Tool.last.lifetime_histograms["Shock"].first["PD Axial"]
  #   assert_equal (histogram_data["vibration"]["si_radial"]["0-10"] * n),
  #                 Tool.last.lifetime_histograms["Vibration"].first["SI Radial"]
  # end

  test 'can save last pump time' do
    tool = create :tool
    time = 1000
    tool.add_pump_time time
    assert_equal time, tool.last_pump_total
  end

  test 'update_cache_json does not delete total_service_time' do
    tool = create :tool
    time = 100
    tool.add_pump_time time
    event = create :event, tool: tool
    tool.touch
    assert_equal time, tool.total_service_time
  end

  test 'adds full pump time when less than previous' do
    tool = create :tool
    times = [ 3000, 2000, 1000 ]
    times.each do |time|
      create :leam_receiver_update, pump_total_time: time, uid: tool.uid
    end
    assert_equal times.reduce(:+), Tool.last.total_service_time
  end

  test 'adds pump time difference when current time is greater' do
    tool = create :tool
    times = [ 1000, 2000, 3000 ]
    times.each do |time|
      create :leam_receiver_update, pump_total_time: time, uid: tool.uid
    end
    assert_equal times.last, Tool.last.total_service_time
  end

  def create_tool args
    Tool.new(args).tap{|m| m.save(validate: false)}
  end

  # def histogram_data
  #   {
  #     "shock" => {
  #       "pd_radial" => { "0-10" => 2,
  #                        "11-20" => 5 },
  #       "pd_axial" => { "0-10" => 4,
  #                       "11-20" => 3 },
  #       "si_radial" => { "0-10" => 1,
  #                        "11-20" => 7 },
  #       "si_axial" => { "0-10" => 6,
  #                       "11-20" => 2 }
  #     },
  #     "vibration" => {
  #       "pd_radial" => { "0-10" => 2,
  #                        "11-20" => 5 },
  #       "pd_axial" => { "0-10" => 4,
  #                       "11-20" => 3 },
  #       "si_radial" => { "0-10" => 1,
  #                        "11-20" => 7 },
  #       "si_axial" => { "0-10" => 6,
  #                       "11-20" => 2 }
  #     },
  #     "temperature" => { "0-10" => 2,
  #                        "11-20" => 5 }
  #   }
  # end

end