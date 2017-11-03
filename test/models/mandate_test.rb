require "test_helper"

class MandateTest < ActiveSupport::TestCase

  test "requires a tool" do
    m = Mandate.new
    m.valid?
    assert_equal true, m.errors[:for_tool_ids].any?
  end

  test "Mandate creates a token" do
    m = Mandate.new
    m.save(validate: false)
    assert m.public_token.present?
  end

  test "Can find a mandate by token" do
    Mandate.delete_all
    m = create_mandate public_token: "foo"
    assert_equal m, Mandate.by_public_token("foo")
  end

  test "can store multiple tool ids" do
    the_tool_ids = ["856", "245", "45*"]
    m = Mandate.new
    m.for_tool_ids = the_tool_ids.join(",")
    m.save(validate: false)
    m.reload
    assert_equal the_tool_ids, m.for_tool_ids
  end

  test "occurences defaults to -1" do
    m = Mandate.new
    m.occurences = -1
    m.valid?
    assert_equal false, m.errors[:occurences].any?
  end
  test "occurences accepts 1" do
    m = Mandate.new
    m.occurences = 1
    m.valid?
    assert_equal false, m.errors[:occurences].any?
  end
  test "occurences does not accept a string or another number" do
    assert_equal true, ["5", "a"].all? do |thing|
      m = Mandate.new
      m.occurences = thing
      m.valid?
      m.errors[:occurences].any?
    end
  end

  test "fields are required" do
    model = Mandate.new
    model.valid?
    %i( contexts).each do |field|
      assert_equal true, model.errors[field].any?, "Field whould have ben required: #{field}"
    end
  end

  test "summary is not required" do
    model = Mandate.new
    model.valid?
    assert_equal false, model.errors[:summary].any?
  end

  test "contexts start empty" do
    assert_equal [], Mandate.new.contexts
  end

  test "serial number list should not overflow at 256 characters" do
    mandate = create(:mandate)
    string = ""
    300.times do
      string += 't'
      end
    mandate.for_tool_ids = string
    mandate.save!
  end

  def create_mandate args
    Mandate.new(args).tap{|m| m.save(validate: false)}
  end
end
