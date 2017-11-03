require "test_helper"

class Push::JobsControllerTest < ActionController::TestCase

  test "missing headers get 401" do
    get :search, search_json
    assert_response 401
  end

  test "wrong headers get 401" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = bad_token
      get :search, search_json
      assert_response 401
    end
  end

  test "should accurately find job" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      job = create(:job, name: search_json[:job_number])
      get :search, search_json
      assert_equal job.id, JSON.parse(response.body)['id']
    end
  end

  test "can hit recent_updates" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      job = create(:job)
      get :recent_updates, id: job.id
      assert_response 200
    end
  end

  test 'can mark job inactive' do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      job = create(:job)
      get :mark_inactive, id: job.id
      assert_response 200
      assert Job.find(job.id).inactive
    end
  end

  test 'can mark job active' do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = good_token
      job = create(:job)
      get :mark_active, id: job.id
      assert_response 200
      assert_not Job.find(job.id).inactive
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end

  def search_json
    { job_number: 'OK-123456' }
  end
end
