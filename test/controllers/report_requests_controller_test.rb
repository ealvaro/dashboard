require "test_helper"

class ReportRequestsControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = user.id
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    user = create(:user)
    @controller.stub(:current_user, user) do
      job = Job.create!(name: "NO-000001")
      params = {report_request:{job_id: job.id.to_s, inc: "123", azm: "33",
                                measured_depth: "23", start_depth:"3",
                                request_survey: true}}
      post :create, params
      assert_redirected_to report_requests_path
    end
  end

  test "should render new if no top-level choice is made" do
    user = create(:user)
    @controller.stub(:current_user, user) do
      job = Job.create!(name: "NO-000001")
      params = {report_request:{job_id: job.id.to_s, inc: "123", azm: "33",
                                measured_depth: "23", start_depth:"3"}}

      post :create, params

      assert_response :success
    end
  end

  test "should clear survey info if no survey requested" do
    user = create(:user)
    @controller.stub(:current_user, user) do
      job = Job.create!(name: "NO-000001")
      params = {report_request:{job_id: job.id.to_s, inc: "123", azm: "33",
                                measured_depth: "23", start_depth:"3",
                                end_depth:"23", las_export: "true",
                                request_reports: "true"}}

      post :create, params

      assert_equal nil, ReportRequest.last.measured_depth
    end
  end

  test "should clear reports info if no report requested" do
  user = create(:user)
    @controller.stub(:current_user, user) do
      job = Job.create!(name: "NO-000001")
      rrt = ReportRequestType.create!(name: "TVD", scaling: "9000")
      params = {report_request:{job_id: job.id.to_s, inc: "123", azm: "33",
                                measured_depth: "23", start_depth:"3",
                                end_depth:"4",
                                request_survey: "true", las_export: "true",
                                report_request_type_ids: [rrt.id]}}

      post :create, params

      assert_equal false, ReportRequest.last.las_export
      assert_equal 0, ReportRequest.last.report_request_types.count
    end
  end

  def test_show
    rr = create(:report_request)
    get :show, {id: rr.id}
    assert_response :success
  end

  def test_index
    get :index
    assert_response :success
  end

  def user
    User.create! email: "the-email@example.com",
      password: "abcabc",
      password_confirmation: "abcabc",
      name: "the-name"
  end

end
