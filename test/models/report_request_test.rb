require "test_helper"

class ReportRequestTest < ActiveSupport::TestCase
  test "should not be valid if there is no job or run specified" do
    rr = build(:report_request)
    rr.job_id = nil
    rr.run_id = nil
    assert !rr.valid?
  end
  test "should be valid if there is a job" do
    rr = build(:report_request)
    assert rr.job
    assert rr.valid?
  end
  test "should be valid if there is a run" do
    run = create( :run )
    rr = build(:report_request, run: run)
    rr.job = nil
    assert rr.run
    assert rr.valid?
  end
  test "should invalid if inc is missing" do
    rr = build(:report_request)
    rr.request_survey = true
    rr.inc = nil
    assert !rr.valid?
  end
  test "should be invalid if start_depth is missing" do
    rr = build(:report_request)
    rr.request_reports = true
    rr.start_depth = nil
    assert !rr.valid?
  end
end
