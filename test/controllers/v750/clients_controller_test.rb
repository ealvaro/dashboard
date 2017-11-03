require "test_helper"

class V750::ClientsControllerTest < ActionController::TestCase
  test "should return visible clients" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      create(:client)
      create(:client, hidden: true)

      get :index

      assert_equal 1, JSON.parse(response.body).length
    end
  end

  def good_token
    "good-token"
  end
end
