require "test_helper"

class RigNotifiersControllerTest < ActionController::TestCase
  setup do
    admin = create(:user, roles: ['Admin'])
    session[:user_id] = admin.id
  end

  test "can get index" do
    get :index
    assert_response 200
  end

  test "can post create" do
    configuration = Notifier.config_from_string("a r + y")
    rig = create :rig
    params = { name: 'orange', configuration: configuration, associated_data: { rig_id: rig.id } }
    assert_difference('RigNotifier.count') do
      post :create, notifier: params
    end
  end
end
