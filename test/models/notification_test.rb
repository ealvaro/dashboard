require "test_helper"

class NotificationTest < ActiveSupport::TestCase

  test "can complete" do
    notification = create(:notification)
    assert_nil(notification.completed_at)

    notification.complete!
    refute_nil(notification.completed_at)
  end

  test "can only complete once" do
    notification = create(:notification)
    notification.complete!
    assert_raises(RuntimeError) do
      notification.complete!
    end
  end

  test "can link to notifiable" do
    report_request = create(:report_request)
    notification = create(:notification, notifiable: report_request)

    refute_nil(notification.notifiable)
  end

  test "can get alerts from followed jobs" do
    user = create(:user)
    user.follow "OK-123456"
    update = create(:btr_receiver_update)
    assert_difference "Notification.following(user).count" do
      notification = create(:notification, notifiable: update)
    end
  end

  test "can search by job number" do
    create_notification
    assert_equal @notification, Notification.search(@notification.job_number).try(:first)
  end

  test "can search by date" do
    create_notification
    assert_equal @notification, Notification.search(@notification.created_at.to_s).try(:first)
  end

  test "can search by user" do
    user = create(:user)
    create_notification({ user: user })
    assert_equal @notification, Notification.search(@notification.user.name).try(:first)
  end

  test "can search by status" do
    create_notification({ completed_status: "Critical" })
    assert_equal @notification, Notification.search(@notification.completed_status).try(:first)
  end

  test "can search by description" do
    create_notification({description: "Azm > 100"})
    assert_equal @notification, Notification.search(@notification.description).try(:first)
  end

  test "can search by old active" do
    create_notification({description: "Azm > 0"})
    create_notification({description: "Azm > 1", created_at: 3.days.ago})
    create_notification({description: "Azm > 2", completed_at: DateTime.now,
                         completed_status: "Resolved"})

    assert_equal 1, Notification.old_active(2.days.ago).count
  end

  test "can search by notifier type" do
    template_notifier = create(:template_notifier)
    create_notification({description: "Inc > 0"})
    create(:notification, {description: "Inc > 1",
                           notifier: template_notifier})

    assert_equal 1, Notification.not_template.count
  end

  test "can join old active and not template" do
    create_notification({description: "Azm > 0"})
    create_notification({description: "Azm > 1", completed_at: DateTime.now,
                         completed_status: "Resolved"})
    template_notifier = create(:template_notifier)
    create(:notification, {description: "Azm > 2",
                           created_at: 3.days.ago,
                           notifier: template_notifier})

    assert_equal 0, Notification.old_active(2.days.ago).not_template.count
  end

  test "return only notifications triggered by non templates" do
    user = create :user
    job = create :job
    template = create :template, job: job, user: user
    notifier = create :template_notifier, notifierable: template
    good = create_notification({description: "Azm > 100"})
    bad = create_notification({description: "Azm < 99", notifier: notifier})
    assert Notification.not_template.include?(good)
    assert_not Notification.not_template.include?(bad)
  end

  test 'can get template notifications for user' do
    user = create :user
    bad_user = create :user, name: 'bad'
    job = create :job
    template = create :template, job: job, user: user
    bad_template = create :template, job: job, user: bad_user
    notifier = create :template_notifier, notifierable: template
    bad_notifier = create :template_notifier, notifierable: bad_template
    good = create_notification({description: "Azm < 99", notifier: notifier})
    bad = create_notification({description: "Azm > 100", notifier: bad_notifier})
    assert Notification.template_notifications_for_user(user).include?(good)
    assert_not Notification.template_notifications_for_user(user).include?(bad)
  end

  test 'can get template notifications for only followed jobs' do
    user = create :user
    job = create :job
    bad_job = create :job, name: 'NO-123456'
    user.follow(job.name)
    update = create(:logger_update, job_number: job.name)
    bad_update = create(:logger_update, job_number: bad_job.name)
    template = create :template, job: job, user: user
    bad_template = create :template, job: bad_job, user: user
    notifier = create :template_notifier, notifierable: template
    bad_notifier = create :template_notifier, notifierable: bad_template
    good = create_notification({description: "Azm < 99", notifier: notifier, notifiable: update})
    bad = create_notification({description: "Azm > 100", notifier: bad_notifier, notifiable: bad_update})
    assert Notification.followed_template_notifications(user).include?(good)
    assert_not Notification.followed_template_notifications(user).include?(bad)
  end

  def create_notification options={}
    @update = create(:logger_update)
    @update_notifier = create(:global_notifier)
    options = {notifier: @update_notifier, notifiable: @update}.merge(options)
    @notification = create(:notification, options)
  end
end
