require "test_helper"

class OrderedVersionTest < ActiveSupport::TestCase

  test "orders simply" do
    sorted = ["1.0.0", "2.0.0"]
      .map{|v| OrderedVersion.new(v)}
      .sort
    assert_equal ["1.0.0", "2.0.0"], sorted.map(&:version)
  end

  test "reversed" do
    sorted = ["2.0.0", "1.0.0"]
      .map{|v| OrderedVersion.new(v)}
      .sort
    assert_equal ["1.0.0", "2.0.0"], sorted.map(&:version)
  end

  test "minor position" do
    sorted = ["2.2.0", "2.1.0"]
      .map{|v| OrderedVersion.new(v)}
      .sort
    assert_equal ["2.1.0", "2.2.0"], sorted.map(&:version)
  end

  test "patch position" do
    sorted = ["2.2.5", "2.2.4"]
      .map{|v| OrderedVersion.new(v)}
      .sort
    assert_equal ["2.2.4", "2.2.5"], sorted.map(&:version)
  end

  test "above 10" do
    sorted = ["12.12.5", "2.2.4"]
      .map{|v| OrderedVersion.new(v)}
      .sort
    assert_equal ["2.2.4", "12.12.5"], sorted.map(&:version)
  end

  test "real-world sorting" do
    given = [
      "1.4.5",
      "11.1.05",
      "12.12.05",
      "2.1.5",
    ]
    expected = [
      "1.4.5",
      "2.1.5",
      "11.1.05",
      "12.12.05",
    ]
    installs = given.map {|version| Install.new(version: version)}
    sorted = installs.sort{|a, b| OrderedVersion.new(a.version) <=> OrderedVersion.new(b.version)}
    assert_equal expected, sorted.map(&:version)


  end
end
