require "test_helper"

class V750::RigsControllerTest < ActionController::TestCase
  test "can hit index" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :index
      assert_response 200
    end
  end

  test "can hit active" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :active
      assert_response 200
    end
  end

  def good_token
    "the-good-token"
  end
end
