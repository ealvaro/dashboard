require "test_helper"

class Push::UsersControllerTest < ActionController::TestCase

 test "missing headers get 401" do
   post :roles, user_json
   assert_response 401
 end

 test "wrong headers get 401" do
   @controller.stub(:auth_token, good_token) do
     @request.headers['X-Auth-Token'] = bad_token
     post :roles, user_json
     assert_response 401
   end
 end

 test "can get new users" do
   @request.headers['X-Auth-Token'] = good_token
   @controller.stub(:auth_token, good_token) do
     get :index
     before = JSON.parse(response.body).count

     user = create(:user)
     get :index
     after = JSON.parse(response.body).count

     assert_equal before + 1, after
   end
 end

  test "can get active alert users" do
   @request.headers['X-Auth-Token'] = good_token
   @controller.stub(:auth_token, good_token) do
     user = create(:user)
     create(:notification, user: user)

     get :alert_users

     assert_equal 1, JSON.parse(response.body).count
   end
 end

  test "test roles" do
    User.create! name: "user name", email: 'fake@email.com', password: '123456', password_confirmation: '123456', roles: Role.all
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)
      post :roles, user_json
      assert_response :success
      assert_equal response.body, Role.lconfig_roles.to_json
    end
  end

  test "test wrong password" do
    User.create! name: "user name", email: 'fake@email.com', password: '123456', password_confirmation: '123456', roles: Role.all
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      assert_equal good_token, @controller.send(:auth_token)
      post :roles, user_bad_json
      assert_response 401
      assert_not_equal response.body, Role.lconfig_roles.to_json
    end
  end

  test "should be case insensitive" do
    User.create! name: "user name", email: 'fake@email.com', password: '123456', password_confirmation: '123456', roles: Role.all
    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      post :roles, { email: "FAKE@Email.COM", password: '123456'}
      assert_response :success
    end
  end

  test "shouldn't send permissions without a valid feature" do
    user = create(:user)

    @request.headers['X-Auth-Token'] = good_token
    @controller.stub(:auth_token, good_token) do
      get :permissions

      assert_response :bad_request
    end
  end

  test "should send permissions for feature" do
    user = create(:user, roles: ['Admin'])
    @controller.stub(:current_user, user) do
      @request.headers['X-Auth-Token'] = good_token
      @controller.stub(:auth_token, good_token) do
        get :permissions, {feature: "Notifier"}

        assert_equal true, JSON.parse(response.body)["Notifier"]["delete"]
      end
    end
  end

  def good_token
    "teh-good-token"
  end

  def bad_token
    "BAD TOKEN"
  end

  def user_json
    { email: 'fake@email.com', password: '123456' }
  end

  def user_bad_json
    { email: 'fake@email.com', password: '111111' }
  end
end
