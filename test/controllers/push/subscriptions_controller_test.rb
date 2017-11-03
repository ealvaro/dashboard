require "test_helper"

class Push::SubscriptionsControllerTest < ActionController::TestCase
  def good_token
    "teh-good-token"
  end

  def bad_token
    "bad"
  end

  test "missing headers get 401" do
    post :create, {format: :json}
    assert_response 401
  end

  test "wrong headers get 401" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = bad_token
      post :create, {format: :json}
      assert_response 401
    end
  end

  test "create a subscription with run id" do
    create(:run)
    create(:user)
    sample_json = {user_id: User.last, run_id: Run.last}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      start_count = Subscription.count
      post :create, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal start_count + 1, Subscription.count
    end
  end

  test "create a subscription with job id" do
    create(:run)
    create(:user)
    sample_json = {user_id: User.last, job_id: Run.last.job}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      start_count = Subscription.count
      post :create, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal start_count + 1, Subscription.count
    end
  end

  test "create a subscription from job name" do
    create(:run)
    create(:user)
    sample_json = {user_id: User.last, job: {name: Run.last.job.name}}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      start_count = Subscription.count
      post :create, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal start_count + 1, Subscription.count
    end
  end

end
