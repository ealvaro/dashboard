require "test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  test "not-logged in user redirects to login" do
    get :show
    assert_redirected_to new_session_path
  end

  test "logged in user without admin role sees 403" do
    session[:user_id] = user.id
    get :show
    assert_response 403
  end

  test "admin-user can see the dashboard" do
    user = User.new( name: "the-name",
                    password: "the-pass",
                    password_confirmation: "the-pass",
                    email: "the-email@example.com",
                    roles: ["Admin"],
                   )
    user.save!
    session[:user_id] = user.id
    get :show
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
