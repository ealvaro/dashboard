require "test_helper"

class FirmwareUpdatesControllerTest < ActionController::TestCase

  setup do
    session[:user_id] = user.id
  end

  test "unauthenticated should not get overview" do
    session[:user_id] = nil
    get :overview
    assert_redirected_to new_session_path
  end

  test "authenticated should get overview" do
    get :overview
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: firmware_update.id
    assert_response :success
  end

  test "should update and last edit by" do
    update = create(:firmware_update)

    put :update, id: update.id, firmware_update: {summary: "updated"}

    assert_equal session[:user_id], FirmwareUpdate.last.last_edit_by_id
    assert_redirected_to overview_firmware_updates_path
  end

  test "should get confirm_delete" do
    get :confirm_delete, id: firmware_update.id
    assert_response :success
  end


  def user
    User.create! email: "the-email@example.com",
      password: "abcabc",
      password_confirmation: "abcabc",
      name: "the-name"
  end

  def firmware_update(args={})
    FirmwareUpdate.new(args).tap{ |f| f.save(validate: false) }
  end

end
