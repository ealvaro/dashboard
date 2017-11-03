require "test_helper"

class InstallTest < ActiveSupport::TestCase

  test "can find_by key or create" do
    install = Install.for_key_or_create(params.except(:key))
    assert install.persisted?
    refute install.key.blank?, "Install key must not be blank"
    assert_equal "the-app", install.application_name
  end

  test "will use the current key" do
    install = Install.for_key_or_create(params.merge(key: "sup-yo"))
    assert_equal "the-app", install.application_name
    assert_equal "sup-yo", install.key
  end

  test "required fields" do
    install = Install.new
    install.valid?
    %i(application_name version ip_address).each do |field|
      assert_equal true, install.errors[field].any?, "Should have required #{field}"
    end
  end

  def params
    {
      application_name: "the-app",
      version: "the-version",
      key: "the-key",
      ip_address: "127.0.0.1",
    }
  end
end
