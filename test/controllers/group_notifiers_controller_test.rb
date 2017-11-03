require "test_helper"

class GroupNotifiersControllerTest < ActionController::TestCase
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
    group = create :rig_group
    params = { name: 'orange', configuration: configuration, associated_data: { group_id: group.id } }
    assert_difference('GroupNotifier.count') do
      post :create, notifier: params
    end
  end
end
