require "test_helper"

class V730::SurveysControllerTest < ActionController::TestCase
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

  test "record a survey" do
    json = {measured_depth: 1000}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      user = create(:user)
      @controller.stub(:current_user, user) do
        run = FactoryGirl.create(:run)
        json.merge!(run_id: run.id, created_at: DateTime.now.to_i)

        post :create, json, "CONTENT_TYPE" => 'application/json'

        assert_response :success
        assert_equal 1, Survey.count
      end
    end
  end

  test "record a survey with job/run number" do
    json = {measured_depth: 1000}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      user = create(:user)
      @controller.stub(:current_user, user) do
        run = FactoryGirl.create(:run)
        json.merge!(job_number: run.job.name,
                    run_number: run.number, created_at: DateTime.now.to_i)

        post :create, json, "CONTENT_TYPE" => 'application/json'

        assert_response :success
        assert_equal 1, Survey.count
      end
    end
  end

  test "survey creation fails if it already exists" do
    json = {measured_depth: 1000}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      user = create(:user)
      @controller.stub(:current_user, user) do
        run = FactoryGirl.create(:run)
        survey = Survey.create measured_depth: 1000,
                               run_id: run.id

        json.merge!(run_id: run.id, created_at: DateTime.now.to_i)

        post :create, json, "CONTENT_TYPE" => 'application/json'

        assert_response 403
        assert_equal 1, Survey.count
      end
    end
  end

  test "update data fails with missing required arguments" do
    json = {}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = FactoryGirl.create(:run)
      survey = Survey.create measured_depth: 13,
                             run_id: run.id

      json.merge!(run_id: run.id, created_at: DateTime.now.to_i)

      post :update, json, "CONTENT_TYPE" => 'application/json'
      assert_response 404
      json = JSON.parse(response.body)
      assert_match "measured depth", json["message"]
    end
  end

  test "update data fails with wrong measured_depth" do
    json = {measured_depth: 1000, start_depth: 100,
            inclination: 0.123, azimuth: 0.456}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = FactoryGirl.create(:run)
      Survey.create(measured_depth: 13,
                    run_id: run.id)

      json.merge!(run_id: run.id, created_at: DateTime.now.to_i)

      post :update, json, "CONTENT_TYPE" => 'application/json'
      assert_response 404
      json = JSON.parse(response.body)
      assert_match "measured depth", json["message"]
    end
  end

  test "update data succeeds with matching measured_depth and run id" do
    json = {measured_depth: 1000, start_depth: 100,
            inclination: "0.123", azimuth: "0.456"}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = FactoryGirl.create(:run)
      Survey.create(measured_depth: 1000,
                    run_id: run.id)

      json.merge!(run_id: run.id, created_at: DateTime.now.to_i)

      post :update, json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      json = JSON.parse(response.body)
      assert_match "updated", json["message"]
    end
  end

  test "update data succeeds with matching measured_depth and job/run number" do
    json = {measured_depth: 1000, start_depth: 100,
            inclination: "0.123", azimuth: "0.456"}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = Job.create!(name: "AK-000047")
      run = Run.create!(number: 1, job: job)

      Survey.create(measured_depth: 1000,
                    run_id: run.id)

      json.merge!(job_number: job.name, run_number: run.number,
                  created_at: DateTime.now.to_i)

      post :update, json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      json = JSON.parse(response.body)
      assert_match "was updated", json["message"]
    end
  end

  test "update data creates a new survey" do
    json = {measured_depth: 1000, start_depth: 100,
            inclination: "0.123", azimuth: "0.456"}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = Job.create!(name: "AK-000047")
      run = Run.create!(number: 1, job: job)

      survey = Survey.create(measured_depth_in_feet: 1000,
                             run_id: run.id)

      json.merge!(job_number: job.name, run_number: run.number,
                  created_at: DateTime.now.to_i)

      post :update, json, "CONTENT_TYPE" => 'application/json'

      assert_equal 2, run.surveys.count
    end
  end

  test "update data updates the survey" do
    json = {measured_depth: 1000, start_depth: 100,
            inclination: "0.123", azimuth: "0.456"}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = Job.create!(name: "AK-000047")
      run = Run.create!(number: 1, job: job)

      survey = Survey.create(measured_depth_in_feet: 1000,
                             run_id: run.id)

      json.merge!(job_number: job.name, run_number: run.number,
                  created_at: DateTime.now.to_i)

      post :update, json, "CONTENT_TYPE" => 'application/json'

      new_survey = run.surveys.where(version_number: 2).first
      assert_equal 100, new_survey.start_depth
      assert_equal "0.123", new_survey.inclination
      assert_equal "0.456", new_survey.azimuth
    end
  end

  test "update data only updates the survey once" do
    json = {measured_depth: 1000, start_depth: 100,
            inclination: "0.123", azimuth: "0.456"}
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      job = Job.create!(name: "AK-000047")
      run = Run.create!(number: 1, job: job)

      survey = Survey.create(measured_depth_in_feet: 1000,
                             start_depth: 100,
                             inclination: "0.123",
                             azimuth: "0.456",
                             run_id: run.id)

      json.merge!(job_number: job.name, run_number: run.number,
                  created_at: DateTime.now.to_i)

      post :update, json, "CONTENT_TYPE" => 'application/json'

      json = JSON.parse(response.body)
      assert_match "Nothing to update", json["message"]
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end
end
