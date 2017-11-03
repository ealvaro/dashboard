require "test_helper"

class NotifiersControllerTest < ActionController::TestCase

  setup do
    admin = create(:user, roles: ['Admin'])
    session[:user_id] = admin.id
  end

  def notifier
    @notifier ||= create(:global_notifier, hidden: false)
  end

  test "can hit index" do
    get :index
    assert_response 200
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show, id: notifier
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: notifier
    assert_response :success
  end

  test "should create new edit on update" do
    notifier = create(:global_notifier)
    configuration = GlobalNotifier.config_from_string("to hide & seek")
    params = { name: 'new edition', configuration: configuration }

    assert_difference('GlobalNotifier.count') do
      put :update, id: notifier, notifier: params
    end
  end

  test "should not be deleted by a regular user" do
    user = create(:user, roles: [])
    session[:user_id] = user.id

    post :destroy, id: notifier
    assert_response :forbidden
  end

  test "should not be deleted but hidden" do
    post :destroy, id: notifier
    assert_equal(notifier.hidden, false)
  end

end
