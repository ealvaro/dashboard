require "test_helper"

class FirmwareUpdateTest < ActiveSupport::TestCase

  test "rejects improper hardware_version" do
    model = FirmwareUpdate.new hardware_version: "102.3"
    model.valid?
    assert_equal true, model.errors[:hardware_version].any?
  end

  test "rejects improper version" do
    model = FirmwareUpdate.new version: "102.3"
    model.valid?
    assert_equal true, model.errors[:version].any?
  end

  test "accepts proper version" do
    model = FirmwareUpdate.new version: "10.2.3"
    model.valid?
    assert_equal false, model.errors[:version].any?
  end

  test "accepts proper hardware version" do
    model = FirmwareUpdate.new hardware_version: "10.2.3"
    model.valid?
    assert_equal false, model.errors[:hardware_version].any?
  end

  test "fields are required" do
    model = FirmwareUpdate.new
    model.valid?
    %i( hardware_version version tool_type version binary hardware_version).each do |field|
      assert_equal true, model.errors[field].any?, "Field should have ben required: #{field}"
    end
  end

  test "summary is not required" do
    model = FirmwareUpdate.new
    model.valid?
    assert_equal false, model.errors[:summary].any?
  end

  test "contexts saves" do
    model = FirmwareUpdate.new contexts: ["Admin", "Shop"]
    model.save(validate: false)
    model.reload
    assert_equal ["Admin", "Shop"], model.contexts
  end

  test "contexts start empty" do
    assert_equal [], FirmwareUpdate.new.contexts
  end

  test "should cleanup regions" do
    fw = FirmwareUpdate.new
    fw.regions = [""]
    assert_equal [], fw.regions
  end

  test "should interact with 'for_serial_numbers' correctly" do
    fw = FirmwareUpdate.new for_serial_numbers: "1,2,3,4"
    assert_equal ['1','2','3','4'], fw.for_serial_numbers
  end
end
