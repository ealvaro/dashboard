require "test_helper"

class ReceiverSettingTest < ActiveSupport::TestCase
  test 'receiver setting factory should work' do
    assert_difference 'ReceiverSetting.count' do
      create(:btr_setting)
    end
  end

  test 'creating a receiver setting without a job should not raise an error' do
    assert_nothing_raised do
      BtrSetting.create
    end
  end

  test 'first setting should have version 1' do
    setting = create(:btr_setting)

    assert_equal 1, setting.version_number
  end

  test 'new settings should have different keys' do
    a = create(:btr_setting)
    b = create(:btr_setting)

    refute_equal a.key, b.key
  end

  test 'cloned setting should have same key' do
    setting = create(:btr_setting)

    duped = dup(setting, setting.rxdt)

    assert_equal setting.key, duped.key
  end

  test 'cloned setting should have different versions' do
    setting = create(:btr_setting)

    duped = setting.versioned_dup

    refute_equal setting.version_number, duped.version_number
  end

  test 'can return latest edit' do
    v1 = create(:btr_setting)
    v2 = dup(v1, 2)

    assert_equal v1.versions.last.rxdt, v2.rxdt
  end

  test 'can return all latest edits without previous versions' do
    a1 = create(:btr_setting)
    a2 = dup(a1, 9000)
    b1 = create(:btr_setting)
    b2 = dup(b1, 42)

    latest = ReceiverSetting.latest_versions

    assert_equal 2, latest.count
  end

  test 'latest edit should have the latest values' do
    v1 = create(:btr_setting)
    v2 = dup(v1, 9000)

    latest = ReceiverSetting.latest_versions

    assert_equal v2.rxdt, latest.first.rxdt
  end


  def dup(setting, rxdt)
    d = setting.versioned_dup
    d.rxdt = rxdt
    d.save
    d
  end
end
