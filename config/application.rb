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

module Skysong
  class Application < Rails::Application
    config.active_record.schema_format = :sql
    config.paths['app/views'] << "app/views/devise"
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = 'Eastern Time (US & Canada)'
  end
end
