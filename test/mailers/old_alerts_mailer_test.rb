require "test_helper"

class OldAlertsMailerTest < ActionMailer::TestCase
  tests OldAlertsMailer

  test "old alerts email" do
    configuration = UpdateNotifier.config_from_string("LoggerUpdate gravity > 1.1")
    notifier = UpdateNotifier.create(name: "High Gravity",
                                     configuration: configuration)
    notifications = [Notification.create(notifier:notifier)]
    user = create( :user, roles: ["Admin"], email: "test@test.com" )

    OldAlertsMailer.alerts_older_than( user, notifications, "2" )
    sent = ActionMailer::Base.deliveries.first

 #   assert_equal [user.email], sent.to
 #   assert_equal "Alerts Older than 2 days", sent.subject
 #   assert sent.body.include?( "events/#{event.id}" )
  end

end
