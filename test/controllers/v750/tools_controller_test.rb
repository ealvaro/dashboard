require "test_helper"

class V750::ToolsControllerTest < ActionController::TestCase

  test "can hit tools route" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :tools
      assert_response :success
    end
  end

  test "can hit tools csv route" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :tools_csv
      assert_response :success
    end
  end

  test "can hit recent_memories route" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :recent_memories
      assert_response :success
    end
  end

  test "can hit memories csv route" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :memories_csv
      assert_response :success
    end
  end

  def good_token
    "good-token"
  end

end
