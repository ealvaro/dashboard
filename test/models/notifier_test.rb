require "test_helper"

class NotifierTest < ActiveSupport::TestCase
  test 'should not be able to initialize a generic notifier' do
    assert_raises(RuntimeError) do
      Notifier.new
    end
  end
end
