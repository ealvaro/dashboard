require "test_helper"

class Push::SurveysControllerTest < ActionController::TestCase

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

  test "with header get 200 and json" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)
      run = FactoryGirl.create(:run)
      post :create, {run_id: run.id, surveys: [],format: :json}
      assert_response :success
    end
  end

  test "record surveys" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/surveys/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = FactoryGirl.create(:run)
      sample_json["run_id"] = run.id
      start_count = run.surveys.count
      post :create, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal start_count + 2, run.surveys.count
    end
  end

  test "can record 2 entries in a batch" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/surveys/batch.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      first_run  = FactoryGirl.create(:run)
      second_run = FactoryGirl.create(:run)
      sample_json.first["run_id"]  = first_run.id
      sample_json.second["run_id"] = second_run.id
      first_start_count  = first_run.surveys.count
      second_start_count = second_run.surveys.count

      post :batch , "runs"=> sample_json, format: :json
      assert_response :success
      assert_equal first_start_count + 2, first_run.surveys.count
      assert_equal second_start_count + 2, second_run.surveys.count
    end
  end

  test "Creates an Import Record" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/surveys/sample.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = FactoryGirl.create(:run)
      sample_json["run_id"] = run.id
      post :create, sample_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      run.surveys.each do |survey|
        assert survey.survey_import_run
      end
    end
  end

  test "with same measured depth, with add a version" do
    sample_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/surveys/sample.json")
    corrections_json = ActiveSupport::JSON.decode File.read("#{Rails.root}/test/fixtures/surveys/corrections.json")
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      run = FactoryGirl.create(:run)
      sample_json["run_id"] = run.id
      corrections_json["run_id"] = run.id
      start_count = run.surveys.count
      post :create, sample_json, "CONTENT_TYPE" => 'application/json'
      post :create, corrections_json, "CONTENT_TYPE" => 'application/json'
      assert_response :success
      assert_equal start_count + 2, run.surveys.where(:version_number => 1).count
      assert_equal 2, run.surveys.where(:version_number => 1).first.versions.count
    end
  end


  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end
end
