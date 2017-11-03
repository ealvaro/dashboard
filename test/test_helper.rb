ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
Rails.application.load_seed
require "minitest/pride"

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all
  include FactoryGirl::Syntax::Methods

  Authority.configure do |config|
    config.logger = Rails.logger
  end
end
