require "test_helper"

class RigNotifierTest < ActiveSupport::TestCase
  test 'can find rig alert by rig' do
    rig = create(:rig)
    rig.name = "Test Rig"
    rig.save
    notifier = create(:rig_notifier, notifierable: rig)
    notifier.save
    assert_equal notifier, RigNotifier.find_by_rig(rig).first
  end

  test 'can grab rig alerts' do
    create(:global_notifier)
    create(:global_notifier)
    create(:rig_notifier)
    assert_equal 1, RigNotifier.count
  end

  test 'can trigger rig alert' do
    job = create(:job)
    job.name = "Test Job"
    job.save
    rig = create(:rig)
    rig.name = "Test Rig"
    rig.save
    create(:rig_notifier, associated_data: { rig: rig.as_json })
    update = create(:logger_update, rig_name: rig.name, gravity: 1)
    update.rig = rig
    update.job = job
    RigNotifier.trigger update
    assert_equal 0, Notification.count
  end

  test 'can trigger just rig alert' do
    job = create(:job)
    job.name = "Test Job"
    job.save
    rig = create(:rig)
    rig.name = "Test Rig"
    rig.save
    create(:rig_notifier, associated_data: { rig: rig.as_json })
    create :global_notifier
    update = create(:logger_update, rig_name: rig.name, gravity: 1)
    update.rig = rig
    update.job = job
    RigNotifier.trigger update
    assert_equal 0, Notification.count
  end

  test 'can save access a rig' do
    rig = create(:rig)
    rig.name = "Test Rig"
    notifier = create(:rig_notifier, notifierable: rig )

    assert_equal rig, notifier.rig
  end
end
