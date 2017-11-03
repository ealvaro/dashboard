require "test_helper"

class Push::ReceiversControllerTest < ActionController::TestCase
  test "if the receiver exists it is returned" do
    ToolType.create!(klass: 'Receiver', description: 'Receiver', number: 4)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)
      receiver = create_receiver
      post :create, {uid: receiver.uid}
      assert_equal(JSON.parse(response.body)["uid"], receiver.uid )
    end
  end

  test "if the receiver doesn't exist a new one is created with the UID" do
    ToolType.create!(klass: 'Receiver', description: 'Receiver', number: 4)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)
      post :create, {uid: "DNE12345"}
      assert_equal( Tool.last.uid, JSON.parse(response.body)["uid"])
    end
  end

  test "if there is no uid given a new receiver is created" do
    ToolType.create!(klass: 'Receiver', description: 'Receiver', number: 4)
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)
      post :create, {}
      assert_equal( Tool.last.uid, JSON.parse(response.body)["uid"])
    end
  end

  def create_receiver(attrs={})
    ToolType.find_by( number: 4 ).tools.create! attrs
  end

  def good_token
    "teh-good-token"
  end
end
