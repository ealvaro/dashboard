require "test_helper"

class SoftwareTypeTest < ActiveSupport::TestCase

  test "requires a name" do
    software_type = SoftwareType.create
    software_type.valid?
    assert_equal true, software_type.errors[:name].any?
  end

  test "validates uniqueness of name" do
    the_name = "the-name"
    first  = SoftwareType.create!(name: the_name)
    second = SoftwareType.new(name: the_name) 
    second.valid?
    assert_equal true, second.errors[:name].any?
  end
end
