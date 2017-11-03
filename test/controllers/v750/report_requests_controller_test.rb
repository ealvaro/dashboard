require "test_helper"

class V750::ReportRequestsControllerTest < ActionController::TestCase

  test "won't alert when incomplete" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/report_requests/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = create(:job)
      rr = create(:report_request)
      sample_json.merge! job_id: job.id, created_at: DateTime.now.to_i, report_request_id: rr.id

      put :respond, sample_json, "CONTENT_TYPE" => 'application/json'

      assert_equal 0, ReportResponse.count
    end
  end

  test "will alert when complete" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/report_requests/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = create(:job)
      rr = create(:report_request)
      sample_json.merge! job_id: job.id, created_at: DateTime.now.to_i, report_request_id: rr.id, failed_at: 1424981004

      put :respond, sample_json, "CONTENT_TYPE" => 'application/json'

      assert_equal 1, ReportResponse.count
    end
  end

  test "can get report data" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = create(:job)
      get :report_data, { job: job.id }
      assert_response 200
    end
  end

  def good_token
    "teh-good-token"
  end
end
