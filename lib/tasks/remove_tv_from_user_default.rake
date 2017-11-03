namespace :users do

  desc "Reset headers"
  task :reset_headers => :environment do
    User.update_all settings: User.default_settings
  end

end