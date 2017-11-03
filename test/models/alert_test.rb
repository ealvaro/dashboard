require "test_helper"

class AlertTest < ActiveSupport::TestCase
  it 'should not be able to initialize a generic alert' do
    exception = assert_raises(RuntimeError) {Alert.new}
    assert exception.message =~ /generic/
  end
end
