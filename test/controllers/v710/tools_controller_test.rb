require "test_helper"

class V710::ToolsControllerTest < ActionController::TestCase
  setup do
    ToolType.find_or_create_by number: 7, klass: "SmartBattery", name: "Smart Battery"
  end

  test 'should initialize a new tool' do
    @controller.stub(:authenticate_request, true) do
      uid = SecureRandom.hex
      count = Tool.count
      post :create, new_tool_json(uid)
      assert_equal count + 1, Tool.count
    end
  end

  test 'should return bad request if the tool uid already exists' do
    @controller.stub(:authenticate_request, true) do
      uid = SecureRandom.hex
      FactoryGirl.create(:tool, uid: uid)
      post :create, new_tool_json(uid)
      assert_response :bad_request
    end
  end

  test 'should use the passed uid for the tool if it does not exist' do
    @controller.stub(:authenticate_request, true) do
      uid = SecureRandom.hex
      post :create, new_tool_json(uid)
      assert_equal uid, Tool.last.uid
    end
  end

  test 'should validate that the uid is long enough' do
    @controller.stub(:authenticate_request, true) do
      uid = SecureRandom.hex[1..6]
      post :create, new_tool_json(uid)
      assert_response :bad_request
    end
  end

  test 'should validate that the uid has no spaces' do
    @controller.stub(:authenticate_request, true) do
      uid = SecureRandom.hex[1..6] + " "
      post :create, new_tool_json(uid)
      assert_response :bad_request
    end
  end

  test 'should set the serial number correctly' do
    @controller.stub(:authenticate_request, true) do
      uid = SecureRandom.hex
      post :create, new_tool_json(uid)
      assert_equal "sample serial number", Tool.last.serial_number
    end
  end

  test 'should assign a new uid if one is not specified' do
    @controller.stub(:authenticate_request, true) do
      Tool.destroy_all
      post :create, new_tool_json(nil)
      assert Tool.find(JSON.parse(response.body)["tool"]["id"]).uid.present?
    end
  end


  def new_tool_json(uid)
    {
      tool_type: 7,
      uid: uid,
      serial_number: "sample serial number"
    }
  end
end
