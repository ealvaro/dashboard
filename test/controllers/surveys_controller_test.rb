require "test_helper"

class SurveysControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = user(["Survey"]).id
  end

  test "survey index 403's if missing role" do
    session[:user_id] = user(["Nope"]).id
    get :index, {job_id: job.id}
    assert_response 403
  end

  test "survey index has success with role and job" do
    get :index, {job_id: job.id}
    assert_response :success
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
    Job.create!(name: "NO-000001")
  end
end
