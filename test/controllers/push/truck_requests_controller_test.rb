require "test_helper"

class Push::TruckRequestsControllerTest < ActionController::TestCase
  setup do
    @region = create :region
    @job = create :job
    @truck_request = create(:truck_request, job: @job,
                            region: @region, status: status)
  end

  test 'can get index' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index
      assert_response 200
    end
  end

  test 'can post create' do
    user = create :user
    time = Time.now
    truck_request = { job_id: @job.id, region_id: @region.id, status: status(context: "shipped") }
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:current_user, user) do
      @controller.stub(:auth_token, good_token) do
        assert_difference 'TruckRequest.count' do
          post :create, truck_request: truck_request
          assert_response 200
        end
      end
    end
    assert "shipped", TruckRequest.last.status["context"]
  end

  test 'can put update' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      truck_request = { job_id: @job.id, region_id: @region.id, status: status(context: "received") }
      put :update, id: @truck_request.id, truck_request: truck_request
      truck_request = TruckRequest.find(@truck_request.id)
      assert_response 200
      assert_equal "received", truck_request.status["context"]
    end
  end


  def good_token
    "teh-good-token"
  end

  def status options={}
    { context: options[:context] || "requested", time: options[:time].try(:to_time) || Time.now, notes: options[:notes] || "Some notes" }
  end
end
