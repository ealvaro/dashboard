require "test_helper"

class Push::SoftwareControllerTest < ActionController::TestCase

  test "missing headers get 401" do
    get :index, {format: :json}
    assert_response 401
  end

  test "wrong headers get 401" do
    @controller.stub(:auth_token, good_token) do 
      @request.headers['X-Auth-Token'] = bad_token
      get :index, {format: :json}
      assert_response 401
    end
  end

  test "with header get 200 and json" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do 
      assert_equal good_token, @controller.send(:auth_token)
      get :index, {format: :json}
      assert_response :success
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end
end
