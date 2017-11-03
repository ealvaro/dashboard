require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "can authenticate" do
    admin = create_user
    assert_equal admin, User.find_by(email: admin.email).try(:authenticate, "yo12345")
  end

  test "won't auth if pw is bad" do
    admin = create_user
    assert_equal false, User.find_by(email: admin.email).try(:authenticate, "BADPASS")
  end

  test "requires pw to match password_confirmation" do
    admin = User.new(password: "a", password_confirmation: "b")
    admin.valid?
    assert_equal true, admin.errors[:password_confirmation].any?
  end

  test "requires a password and password_confirmation" do
    %w(password name).each do |field|
      admin = User.new
      admin.valid?
      assert_equal true, admin.errors[field].any?, "Should have required #{field}"
    end
  end

  test "roles start empty" do
    assert_equal [], User.new.roles
  end

  test "can save roles" do
    user = create_user
    user.roles = ["sup"]
    user.save!
    user.reload
    assert_equal ["sup"], user.roles
  end

  test "can follow job" do
    user = create_user
    job = "OK-123456"
    user.follow job
    assert user.follows? job
  end

  test "can unfollow job" do
    user = create_user
    job = "OK-123456"
    user.unfollow job
    assert_not user.follows? job
  end

  test "can search user by name" do
    user = create_user
    assert_equal user, User.search(user.name).try(:first)
  end

  test "can search user by email" do
    user = create_user
    assert_equal user, User.search(user.email).try(:first)
  end

  test "will strip whitespace on email" do
    user = create(:user, email: " leading@whitespace.trailing ")

    assert_equal "leading@whitespace.trailing", user.email
  end

  def create_user
    FactoryGirl.create :user
  end

  def create_notification options={}
    @update = create(:logger_update)
    @update_notifier = create(:global_notifier)
    options = {notifier: @update_notifier, notifiable: @update}.merge(options)
    @notification = create(:notification, options)
  end
end
