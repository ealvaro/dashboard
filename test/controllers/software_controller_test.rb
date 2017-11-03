require "test_helper"

class SoftwareControllerTest < ActionController::TestCase
  test "should redirect to s3" do
    @software = software_type.software.build
    @software.version = "1.0.0"
    @software.installer_name = "foo_file"
    @software.save!

    get :latest, { software_type: "foo" }
    assert_redirected_to @software.binary.url
  end

  test "should redirect to s3 for latest" do
    @latest_software = software_type.software.build
    @latest_software.version = "1.2.0"
    @latest_software.installer_name = "latest_foo_file"
    @latest_software.save!

    @software = software_type.software.build
    @software.version = "1.0.0"
    @software.installer_name = "foo_file"
    @software.save!

    get :latest, { software_type: "foo" }
    assert_redirected_to @latest_software.binary.url
  end

  test "overview should show only the latest software" do
    session[:user_id] = user.id

    @latest_software = software_type.software.build
    @latest_software.version = "1.2.0"
    @latest_software.summary = "latest foo"
    @latest_software.save!

    @software = software_type.software.build
    @software.version = "1.0.0"
    @software.summary = "a foo"
    @software.save!

    get :overview

    assert_match "Latest Version: 1.2.0", response.body
    refute_match "Latest Version: 1.0.0", response.body
  end

  test "delete should remove software" do
    session[:user_id] = user.id

    @software = software_type.software.build
    @software.version = "1.0.0"
    @software.installer_name = "foo_file"
    @software.save!

    assert_difference('Software.count', -1, 'A Software should be destroyed') do
      delete :destroy, { id: @software.id }
    end

    assert_redirected_to overview_software_index_path
  end

  def software_type(name="foo")
    software_type = SoftwareType.find_or_initialize_by(name: name)
    software_type.save
    software_type
  end

  def user
    User.create!(name: "the-name",
                 password: "the-pass",
                 password_confirmation: "the-pass",
                 email: "the-email@example.com",
                )
  end

end
