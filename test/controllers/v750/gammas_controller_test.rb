require "test_helper"

class V750::GammasControllerTest < ActionController::TestCase

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
      assert_response :success
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
      assert_response :success
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

  test "update with new_measured_depth should update measured_depth" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma, measured_depth: 333, count: 1)

      patch :update, {  id: gamma.id,
                        new_measured_depth: 340,
                        measured_depth: gamma.measured_depth,
                        count: gamma.count,
                        job_number: gamma.job.name }

      assert_equal 340, Gamma.first.measured_depth
      assert_response :success
    end
  end

  test "updates with new_measured_depth should update all their measured_depth" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      gamma = create(:gamma, measured_depth: 333, count: 1)

      patch :updates, { gammas: [ { id: gamma.id,
                                    new_measured_depth: 340,
                                    measured_depth: gamma.measured_depth,
                                    count: gamma.count,
                                    job_number: gamma.job.name } ] }

      assert_equal 340, Gamma.first.measured_depth
      assert_response :success
    end
  end

  def good_token
    "the-good-token"
  end

end
