require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Tracker
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.generators do |g|
      g.test_framework :mini_test, :spec => false, :fixture => false
    end
    I18n.enforce_available_locales = false
    config.active_support.escape_html_entities_in_json = false

    config.action_mailer.default_url_options = { :host => ENV["HOST_URL_FOR_MAILER"] }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.smtp_settings = {
      :address   => "smtp.mandrillapp.com",
      :port      => 2525, # ports 587 and 2525 are also supported with STARTTLS
      :user_name => ENV["MANDRILL_USERNAME"],
      :password  => ENV["MANDRILL_APIKEY"], # SMTP password is any valid API key
      :authentication => 'plain', # Mandrill supports 'plain' or 'login'
      :domain => "heroku.com", # your domain to identify your server when connecting
      :enable_starttls_auto => true
    }

    config.autoload_paths += %W(#{config.root}/lib/debug)

    config.angular_templates.ignore_prefix = "templates"

  end
end
