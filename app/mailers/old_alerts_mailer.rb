class OldAlertsMailer < ActionMailer::Base
  default from: ENV["FROM_EMAIL"]

  def alerts_older_than(user, notifications, days)
    @user = user
    @notifications = notifications
    @days = days
    mail to: user.email, subject: "Alerts Older than " + days.to_s + " days"
  end

end
