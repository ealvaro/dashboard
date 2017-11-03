require "test_helper"

class V730::GammasControllerTest < ActionController::TestCase

  test "missing headers get 401" do
    post :create

    assert_response 401
  end

  test "wrong headers get 401" do
    @controller.stub(:auth_token, good_token) do
      @request.headers['X-Auth-Token'] = bad_token

      post :create

      assert_response 401
    end
  end

  test "a create without a job_number/run_number or run_id should return 400" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create

      assert_response 400
    end
  end

  test "record a gamma with run id" do
    sample_json = gamma_fixture
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = create(:run)
      sample_json.merge! run_id: run.id

      post :create, sample_json, "CONTENT_TYPE" => 'application/json'

      assert_response :success
      assert_equal 1, Gamma.count
    end
  end

  test "record a gamma with job number/run number" do
    sample_json = gamma_fixture
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = create(:run)
      sample_json.merge!(job_number: run.job.name, run_number: run.number)

      post :create, sample_json, "CONTENT_TYPE" => 'application/json'

      assert_response :success
      assert_equal 1, Gamma.count
    end
  end

  test "record multiple gammas" do
    sample_json = {gammas: [{measured_depth: 1000, count: 5},
                            {measured_depth: 2000, count: 5}]}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = create(:run)
      sample_json[:gammas][0].merge!(run_id: run.id)
      sample_json[:gammas][1].merge!(job_number: run.job.name,
                                     run_number: run.number)

      post :create, sample_json, "CONTENT_TYPE" => 'application/json'

      assert_response :success
      assert_equal 2, Gamma.count
      assert_equal 5, Gamma.last.count
    end
  end

  test "get edits without job_number/run number or run_id should return 400" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :edits

      assert_response 400
    end
  end

  test "should return all edited gammas" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = create(:run)
      create(:gamma, run: run)
      create(:gamma, count: 300, run: run)
      create(:gamma, count: 301, run: run)

      get :edits, { job_number: run.job.name, run_number: run.number }

      assert_equal 2, JSON.parse(response.body).length
    end
  end

  test "should return all edited gammas only from the requested job" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:gamma, count: 111)
      run = create(:run)
      create(:gamma, count: 222, run: run)
      create(:gamma, count: 333, run: run)

      get :edits, run_id: run.id

      assert_equal 2, JSON.parse(response.body).length
    end
  end

  test "nonexistent gamma returns error" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      patch :update, { id: 2048, count: 3 }

      assert_response 400
    end
  end

  test "update without count returns error" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :update, { id: gamma.id }

      assert_response 400
    end
  end

  test "update should update the count" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :update, { id: gamma.id, count: 123 }

      assert_equal 123, Gamma.first.count
      assert_response :success
    end
  end

  test "updates should update the counts with ids" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :updates, { gammas: [{ id: gamma.id, count: 123 }] }

      assert_equal 123, Gamma.first.count
    end
  end

  test "updates should update the counts with job/run/md/old_count" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :updates, { gammas: [{ job_number: gamma.job.name,
                                   run_number: gamma.run.number,
                                   measured_depth: gamma.measured_depth,
                                   old_count: gamma.count,
                                   count: 123 }] }

      assert_equal 123, Gamma.first.count
    end
  end

  test "updates without a job_number or job_id should return 400" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :updates, { gammas: [{ count: 123 }] }

      assert_response 400
    end
  end

  test "update with count_missing should revert the value" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma, edited_count: 333)

      patch :update, { id: gamma.id, count_missing: true }

      assert_equal gamma.count, Gamma.first.count
      assert_equal gamma.count, Gamma.first.edited_count
    end
  end

  test "updates with count_missing should revert the value" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma, edited_count: 999)

      patch :updates, { gammas: [{ id: gamma.id, count_missing: true }] }

      assert_equal gamma.count, Gamma.first.count
      assert_equal gamma.count, Gamma.first.edited_count
    end
  end

  test "ignores updates with far enough MD" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :updates, { gammas: [{ job_number: gamma.job.name,
                                   run_number: gamma.run.number,
                                   measured_depth: gamma.measured_depth + 1e-6,
                                   old_count: gamma.count,
                                   count: 123 }] }

      assert_equal 321, Gamma.first.count
    end
  end

  test "updates with close enough MD" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :updates, { gammas: [{ job_number: gamma.job.name,
                                   run_number: gamma.run.number,
                                   measured_depth: gamma.measured_depth + 1e-7,
                                   old_count: gamma.count,
                                   count: 123 }] }

      assert_equal 123, Gamma.first.count
    end
  end

  test "count edit should update the edited_count" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :request_edit, { id: gamma.id, count: 123 }

      assert_equal 123, Gamma.first.edited_count
      assert_equal gamma.count, Gamma.first.count
    end
  end

  test "count edit shouldn't update with small enough delta" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma)

      patch :request_edit, { id: gamma.id, count: 321.0000005 }

      assert_equal 321, Gamma.first.edited_count
    end
  end

  def gamma_fixture
    { measured_depth: 1000, count: 100 }
  end

  def good_token
    "the-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end

end
