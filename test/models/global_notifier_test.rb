require "test_helper"

class GlobalNotifierTest < ActiveSupport::TestCase
  test 'it should create' do
    create(:global_notifier, name: "A")

    assert_equal "A", GlobalNotifier.last.name
  end
end
