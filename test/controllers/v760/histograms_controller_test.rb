require "test_helper"

class V760::HistogramsControllerTest < ActionController::TestCase

  test 'can post create' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_difference 'Histogram.count' do
        tool_ids = { tool_ids: [create(:tool).id] }
        post :create, histogram: build(:histogram).as_json.merge(tool_ids)
        assert_response 200
      end
    end
  end

  test 'can put update' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      old_job = create(:job).id
      new_job = create(:job).id
      tools = [create(:tool).id]
      histogram = create(:histogram, job_id: old_job)
      put :update, id: histogram.id,
                   histogram: histogram.as_json.merge({ "job_id" => new_job,
                                                        "tool_ids" => tools})
      assert_response 200
      assert_equal new_job, Histogram.find(histogram.id).job_id
      assert_equal tools, Histogram.find(histogram.id).tools.pluck(:id)
    end
  end

  def good_token
    "teh-good-token"
  end
end