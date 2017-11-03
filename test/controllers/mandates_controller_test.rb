require "test_helper"

class MandatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_redirected_to new_session_path
  end

  test "should get new" do
    get :new
    assert_response :redirect
  end

  test "once logged in" do
    session[:user_id] = user.id
    get :index
    assert_response :success
  end

  def user
    User.create!(name: "the-name",
                 password: "the-pass",
                 password_confirmation: "the-pass",
                 email: "the-email@example.com",
                )
  end

end
