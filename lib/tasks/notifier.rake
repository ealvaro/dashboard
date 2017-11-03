namespace :notifier do
  desc "Reset associated_data"
  task :reset_associated_data => :environment do
    Notifier.update_all(associated_data: {})
  end
end