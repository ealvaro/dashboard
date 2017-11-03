require "test_helper"

class GlobalNotifiersControllerTest < ActionController::TestCase
  setup do
    admin = create(:user, roles: ['Admin'])
    session[:user_id] = admin.id
  end

  test "can get index" do
    get :index
    assert_response 200
  end

  test "can post create" do
    configuration = GlobalNotifier.config_from_string("a r + y")
    params = { name: 'orange', configuration: configuration }

    assert_difference('GlobalNotifier.count') do
      post :create, notifier: params
    end
  end
end