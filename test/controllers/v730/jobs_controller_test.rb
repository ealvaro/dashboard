require "test_helper"

class V730::JobsControllerTest < ActionController::TestCase
  test "bad receiver update headers should get a 401" do
    @request.headers['X-Auth-Token'] = "bad-token"
    @controller.stub(:auth_token, good_token) do
      post :receiver_updates, sample_json

      assert_response 401
    end
  end

  test "good receiver update headers should get a success response" do
    create(:job, name: "OK-140504")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)
      post :receiver_updates, sample_json

      assert_response :success
    end
  end

  test "no job number in receiver update params gets a warning in response" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      s = sample_json
      s.delete("job")

      post :receiver_updates, s

      assert_match /supply a valid job number/, JSON.parse(response.body)["message"]
    end
  end

  test "bad job number in receiver update params gets a warning in response" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      s = sample_json
      s["job"] = "a"
      post :receiver_updates, s

      assert_match /supply a valid job number/, JSON.parse(response.body)["message"]

      s["job"] = "AB-"
      post :receiver_updates, s

      assert_match /supply a valid job number/, JSON.parse(response.body)["message"]

      s["job"] = "AB-12345G"
      post :receiver_updates, s

      assert_match /supply a valid job number/, JSON.parse(response.body)["message"]
    end
  end

  test "no receiver type in receiver update params defaults and passes" do
    create(:job, name: "OK-140504")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      s = sample_json
      s.delete("receiver_type")

      post :receiver_updates, s

      assert_response :success
    end
  end

  test "bad receiver type in receiver update params gets a warning in response" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      s = sample_json
      s["receiver_type"] = "something else entirely"

      post :receiver_updates, s

      assert_match /supply a valid receiver type/, JSON.parse(response.body)["message"]
    end
  end

  test "job gets touched on receiver update" do
    job_number = sample_json["job"].upcase
    job = Job.create!(name: job_number)
    two_days_ago = set_updated_back_from_now_by(2.days, job)

    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      post :receiver_updates, sample_json

      refute_equal(two_days_ago, Job.find_by_name(job_number)["updated_at"])
    end
  end

  test "no job matching the job number should return 400" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      post :receiver_updates, sample_json

      assert_response 400
    end
  end

  def set_updated_back_from_now_by(time_delta, object)
    object.updated_at = DateTime.now - time_delta

    ActiveRecord::Base.record_timestamps = false
    object.save
    ActiveRecord::Base.record_timestamps = true

    object.updated_at
  end

  test "no job number in logger update params gets a warning in response" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      s = logger_sample_json
      s.delete("job")

      post :logger_updates, s

      assert_match /supply a valid job number/, JSON.parse(response.body)["message"]
    end
  end

  test "bad job number in logger update params gets a warning in response" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      s = logger_sample_json
      s["job"] = "a"
      post :logger_updates, s

      assert_match /supply a valid job number/, JSON.parse(response.body)["message"]

      s["job"] = "AB-"
      post :logger_updates, s

      assert_match /supply a valid job number/, JSON.parse(response.body)["message"]

      s["job"] = "AB-12345G"
      post :logger_updates, s

      assert_match /supply a valid job number/, JSON.parse(response.body)["message"]
    end
  end

  test "good job number in logger update params gets a successful in response" do
    j = Job.create(name: "OK-150490")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)

      post :logger_updates, logger_sample_json.merge(job: j.name)

      assert_match /Successfully/, JSON.parse(response.body)["message"]
    end
  end

  def sample_json
    ActiveSupport::JSON.decode( File.read("#{Rails.root}/test/fixtures/active_jobs/receiver.json") )
  end

  def logger_sample_json
    ActiveSupport::JSON.decode( File.read("#{Rails.root}/test/fixtures/active_jobs/logger.json") )
  end

  def good_token
    "teh-good-token"
  end
end
