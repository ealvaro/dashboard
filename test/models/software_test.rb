require "test_helper"

class SoftwareTest < ActiveSupport::TestCase

  test "requires a software test" do
    software = Software.new
    software.valid?
    assert_equal true, software.errors[:software_type].any?
  end
  test "requires a version" do
    software = Software.new
    software.valid?
    assert_equal true, software.errors[:version].any?
  end
  test "Sets binary to installer_name" do
    software = Software.new installer_name: "thename.hex"
    software.valid?
    assert_equal software.installer_name, "thename.hex"
  end
end
