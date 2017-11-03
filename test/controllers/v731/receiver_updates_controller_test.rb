require "test_helper"

class V731::ReceiverUpdatesControllerTest < ActionController::TestCase
  include ReceiverUpdatesControllerTestHelper

  test 'should assign uid' do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :create, json

      update = Update.find JSON.parse(response.body)["id"]
      assert update.uid.present?, "Need to set UID"
    end
  end
end
