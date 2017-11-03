require "test_helper"

class JobsControllerTest < ActionController::TestCase
  setup do
    session[:user_id] = user.id
  end

  test "receiver show 404's if id missing" do
    get :show_receiver, {id: 1}
    assert_response 404
  end

  test "receiver show has success response if job exists" do
    job = Job.create!(name: "UM-000000")
    get :show_receiver, {id: job.id}
    assert_response :success
  end

  test "can hit receiver settings show" do
    job = Job.create!(name: "UM-000000")
    get :show_receiver_settings, {id: job.id}
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
