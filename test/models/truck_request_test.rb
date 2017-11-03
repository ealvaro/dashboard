require "test_helper"

class TruckRequestTest < ActiveSupport::TestCase
  setup do
    @region = create :region
    @job = create :job
  end

  test 'validates presence of job' do
    request = TruckRequest.new
    assert_not request.valid?
  end

  test 'can get active requests' do
    active = create(:truck_request, status: status(context: 'requested'), job: @job, region: @region)
    completed = create(:truck_request, status: status(context: 'received'), job: @job, region: @region)
    assert TruckRequest.active.include?(active)
    assert_not TruckRequest.active.include?(completed)
  end

  test 'can get completed requests' do
    active = create(:truck_request, status: status(context: 'requested'), job: @job, region: @region)
    completed = create(:truck_request, status: status(context: 'received'), job: @job, region: @region)
    assert TruckRequest.completed.include?(completed)
    assert_not TruckRequest.completed.include?(active)
  end

  test 'can search by date' do
    time_now = Time.now
    time_last_week = 1.week.ago
    now = create(:truck_request, status: status(time: time_now.to_s), job: @job, region: @region, created_at: time_now)
    last_week = create(:truck_request, status: status(time: time_last_week.to_s), job: @job, region: @region, created_at: time_last_week)

    result = TruckRequest.search("#{time_now.mon}/#{time_now.day}/#{time_now.year}")
    assert result.include? now
    assert_not result.include? last_week
    result = TruckRequest.search("#{time_last_week.mon}/#{time_last_week.day}/#{time_last_week.year}")
    assert result.include? last_week
    assert_not result.include? now
  end

  test 'can search by string' do
    searches = [ priority = 'medium',
                 context = "acknowledged",
                 mwd_tools = "yeymwd",
                 surface_equipment = "yeysurface" ]

    good_request = create(:truck_request, priority: priority, job: @job,
                           region: @region, status: status(context: context),
                           mwd_tools: mwd_tools,
                           surface_equipment: surface_equipment)
    bad_request = create(:truck_request, job: @job, region: @region)

    searches.each do |search|
      result = TruckRequest.search(search)
      assert result.include? good_request
      assert_not result.include? bad_request
    end
  end

  test 'can update status' do
    new_status = status(context: "acknowledged")
    request = create(:truck_request, job: @job, status: status)
    request.status = new_status
    assert request.status["context"] == new_status["context"]
  end

  test 'saves status history' do
    old_status = status
    new_status = status(context: "acknowledged")
    request = create(:truck_request, job: @job, status: old_status)
    request.status = new_status
    assert request.status_history.include? old_status
    assert_not request.status_history.include? new_status
  end

  test 'will force utf8 on mwd_tools' do
    tr = create :truck_request, mwd_tools: bad_string
    assert_equal tr.mwd_tools, good_string
  end

  test 'will force utf8 on motors' do
    tr = create :truck_request, motors: bad_string
    assert_equal tr.motors, good_string
  end

  test 'will force utf8 on surface_equipment' do
    tr = create :truck_request, surface_equipment: bad_string
    assert_equal tr.surface_equipment, good_string
  end

  test 'will force utf8 on backhaul' do
    tr = create :truck_request, backhaul: bad_string
    assert_equal tr.backhaul, good_string
  end

  def status options={}
    { context: options[:context] || "requested", time: options[:time].try(:to_time) || Time.now, notes: "Some notes" }.as_json
  end

  def bad_string
    "good\x96"
  end

  def good_string
    "good"
  end
end