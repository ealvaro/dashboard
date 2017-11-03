require "test_helper"

class GroupNotifierTest < ActiveSupport::TestCase
  test 'can grab group alerts' do
    create(:group_notifier)
    create(:global_notifier)
    create(:rig_notifier)
    assert_equal 1, GroupNotifier.count
  end
end
