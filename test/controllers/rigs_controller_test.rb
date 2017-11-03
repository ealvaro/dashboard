require "test_helper"

class RigsControllerTest < ActionController::TestCase

  setup do
    session[:user_id] = user(["client-info"]).id
  end

  test "can hit index" do
    get :index
    assert_response 200
  end

  test "can hit active" do
    get :active
    assert_response 200
  end

  def user(roles)
    @count = @count.to_i.succ
    User.create! name:"the-name",
                 password: "the-pass",
                 password_confirmation: "the-pass",
                 email: "the-email-#{@count}@example.com",
                 roles: roles
  end
end
