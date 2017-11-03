require "test_helper"

class V730::ReportRequestsControllerTest < ActionController::TestCase

  test "missing headers get 401" do
    get :index
    assert_response 401
  end

  test "wrong headers get 401" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = bad_token
      get :index
      assert_response 401
    end
  end

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

  test "should include report types" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      rr = create(:report_request)
      rr = create(:report_request, job: rr.job)
      rrt = ReportRequestType.create!(name: "TVD", scaling: "1")
      rr.report_request_types << [rrt]
      rr.save

      get :index, {job_id: rr.job.id, all: true}

      assert_match "TVD", response.body
    end
  end

  test "should include report types under logviz_formats" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      rr = create(:report_request)
      rr = create(:report_request, job: rr.job)
      rrt = ReportRequestType.create!(name: "TVD", scaling: "2")
      rr.report_request_types << [rrt]
      rr.save

      get :index, {job_id: rr.job.id, all: true}

      assert_match "logviz_formats", response.body
      refute_match "report_request_types", response.body
    end
  end

  test "should include LAS Export as separate field" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      rr = create(:report_request, las_export: true)

      get :index, {job_id: rr.job.id, all: true}

      assert_match "las_export", response.body
      assert_equal true, JSON.parse(response.body).first()["las_export"]
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end
end
