require "test_helper"

class V760::ToolsControllerTest < ActionController::TestCase

  test "create can find by uid" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = create :tool
      post :create, tool: tool.as_json
      assert_response 200
      assert_not_nil assigns(:tool)
      assert_equal assigns(:tool), tool
    end
  end

  test "create can find by tool_type and serial" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = create :tool
      post :create, tool: tool.as_json.merge({"uid" => nil})
      assert_response 200
      assert_not_nil assigns(:tool)
      assert_equal assigns(:tool), tool
    end
  end

  test "create new if no uid" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      tool = build(:tool)
      post :create, tool: tool.as_json
      assert_response 200
      assert_not_nil assigns(:tool)
      assert_equal tool.serial_number, assigns(:tool).serial_number
      assert_equal tool.tool_type, assigns(:tool).tool_type
    end
  end

  test "can get new dumb tool" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_difference 'Tool.count' do
        tool_type = create(:tool_type).number
        post :new_dumb_tool, tool_type: tool_type
        assert_response 200
      end
    end
  end

  def good_token
    "teh-good-token"
  end
end