require "test_helper"

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    session[:user_id] = @user.id
  end

  test "can hit follow endpoint" do
    get :follow, user: { job: "OK-123456" }
    assert_response 200
  end

  test "can hit unfollow endpoint" do
    get :unfollow, user: { job: "OK-123456" }
    assert_response 200
  end

end
