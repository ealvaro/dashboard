# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Tracker::Application.load_tasks

# Run all tests by default please
# Apparently this is fixed in a subsequent version of minitest-rails
namespace "minitest" do
  task(:default).clear.enhance ['minitest:all']
end
