require "test_helper"

class V770::NotificationsControllerTest < ActionController::TestCase
  setup do
    @user = create :user
  end

  test "should return active notifications by default" do
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      @controller.stub(:current_user, @user) do
        get :index
        assert_response 200
      end
    end
  end

  def good_token
    "good-token"
  end
end