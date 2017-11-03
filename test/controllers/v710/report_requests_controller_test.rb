require "test_helper"

class V710::ReportRequestsControllerTest < ActionController::TestCase
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


  ##CREATE
  test "record a report request" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/report_requests/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      user = create(:user)
      @controller.stub(:current_user, user) do
        job = create(:job)
        sample_json.merge! job_id: job.id, created_at: DateTime.now.to_i
        post :create, sample_json, "CONTENT_TYPE" => 'application/json'
        assert_response :success
        assert_equal 1, ReportRequest.count
      end
    end
  end

  test "record a report request and add a requested by user" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/report_requests/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      user = create(:user)
      @controller.stub(:current_user, user) do
        job = create(:job)
        sample_json.merge! job_id: job.id, created_at: DateTime.now.to_i
        post :create, sample_json, "CONTENT_TYPE" => 'application/json'
        assert_equal user.id, ReportRequest.last.requested_by.id
      end
    end
  end


  ##RESPOND
  test "create two new assets" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/report_requests/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = create(:job)
      rr = create(:report_request)
      sample_json.merge! job_id: job.id, created_at: DateTime.now.to_i, report_request_id: rr.id
      put :respond, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal 2, ReportRequestAsset.count
    end
  end

  test "should mark it as failed" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/report_requests/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = create(:job)
      rr = create(:report_request)
      sample_json.merge! job_id: job.id, created_at: DateTime.now.to_i, report_request_id: rr.id, failed_at: 1424981004
      put :respond, sample_json, "CONTENT_TYPE" => 'application/json'
      assert ReportRequest.last.failed?
    end
  end

  ##INDEX
  test "a request without a job_number or job_id should return 400" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index
      assert_response 400
    end
  end

  test "should return all report requests" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      rr = create(:report_request)
      create(:report_request, job: rr.job, succeeded_at: DateTime.now)
      create(:report_request, job: rr.job, failed_at: DateTime.now)
      get :index, {job_id: rr.job.id, all: true}
      assert_equal 3, JSON.parse(response.body).length
    end
  end

  test "should return all active report requests" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:report_request)
      create(:report_request, succeeded_at: DateTime.now)
      create(:report_request, failed_at: DateTime.now)
      get :index
      assert_equal 1, JSON.parse(response.body).length
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end
end
