require "test_helper"

class DrillerSurveysControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = user(["Directional Drilling"]).id
  end

  test "driller survey index 403's if missing role" do
    session[:user_id] = user(["Nope"]).id
    get :index
    assert_response 403
  end

  test "unauthenticated driller should get login" do
    session.delete("user_id")
    get :index
    assert_redirected_to new_session_path
  end

  test "driller index has success with role and job" do
    make_run 1, job
    get :index
    assert_response :success
  end

  test "driller index doesn't display application template" do
    make_run 1, job
    get :index
    refute_match "navbar", response.body
  end

  test "driller index with less than 3 surveys shows warning" do
    make_run 1, job
    get :index
    assert_match "add at least three surveys", response.body
  end

  test "driller index with 3 or more surveys suppresses warning" do
    run = make_run 1, job
    survey(run, 1001)
    survey(run, 1002)
    survey(run, 1003)
    get :index
    refute_match "add at least three surveys", response.body
  end

  test "driller index only displays surveys for requested job" do
    hidden_job = Job.create!(name: "DD-000001")
    hidden_run = make_run(1, hidden_job)
    survey(hidden_run, 1000)

    target_run = make_run(1, job)
    survey(target_run, 1001)

    get :index
    refute_match "1000", response.body
    assert_match "1001", response.body
  end

  test "driller index only displays surveys for requested run" do
    shared_job = job
    hidden_run = make_run(1, shared_job)
    survey(hidden_run, 1000)

    target_run = make_run(2, shared_job)
    survey(target_run, 1001)

    get :index
    refute_match "1000", response.body
    assert_match "1001", response.body
  end

  test "driller can add a new survey" do
    run = create(:run, number: 1, job: job)
    post :create, {survey: {measured_depth: "1000", run_id: run.id}}
    assert_redirected_to driller_surveys_path
    assert_equal 1, Survey.count
  end

  def user(roles)
    @count = @count.to_i.succ
    User.create! name:"the-name",
                 password: "the-pass",
                 password_confirmation: "the-pass",
                 email: "the-email-#{@count}@example.com",
                 roles: roles
  end

  def job
    session[:job_id] = Job.create! name: "DD-000000"
  end

  def make_run(number, job)
    session[:run_id] = Run.create! number: number, job: job
  end

  def survey(run, measured_depth)
    Survey.create! run: run, measured_depth_in_feet: measured_depth,
                   inclination: 346, azimuth: 34
  end
end
