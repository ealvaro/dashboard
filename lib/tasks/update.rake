namespace :tracker do
  namespace :updates do
    desc 'Delete old updates'
    task :delete_old_updates => :environment do
      $stdout.write "Deleting old updates"
      Update.destroy_old
      # Update.where("created_at < ?", 2.days.ago).delete_all
      $stdout.flush
      $stdout.write("\n")
    end

    desc 'Destroy old updates'
    task :destroy_old_updates => :environment do
      $stdout.write "Destroying old updates"
      Update.destroy_old
      # Update.where("created_at < ?", 2.days.ago).destroy_all
      $stdout.flush
      $stdout.write("\n")
    end

    desc 'Trigger alerts'
    task :trigger_alerts => :environment do
      $stdout.write "Triggering alerts"
      UpdateNotifier.trigger_from_last_updates
      $stdout.flush
      $stdout.write("\n")
    end

    desc "Convert updates"
    task :convert => :environment do
      Update.all.each do |update|
        update.associate_job
        update.associate_rig
        update.add_to_recent_updates
        update.save
      end
    end
  end
end