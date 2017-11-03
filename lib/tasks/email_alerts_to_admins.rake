namespace :tracker do
    desc 'Email all admins about active Alerts'
    task :email_active_alerts => :environment do
      $stdout.write "Finding active Alerts longer than 2 days"
      notifications = Notification.old_active(2.days.ago).not_template
      $stdout.write "Finding all Admins"
      users = User.all
      if !notifications.empty?
        users.each {|u| OldAlertsMailer.alerts_older_than(u, notifications, 2).deliver if u.has_role?(:admin)}
      end
    end
end
