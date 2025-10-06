require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'capybara/rspec'
require 'rspec/rails'
require 'securerandom'
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'channels'
  add_filter 'mailers'
  add_filter 'jobs'
  add_filter 'helpers'
end

Capybara.register_driver :selenium_chrome_headless do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--headless')
    opts.add_argument('--no-sandbox')
    opts.add_argument('--disable-dev-shm-usage')
    opts.add_argument("--user-data-dir=/tmp/test-profile-#{SecureRandom.uuid}")
  end

  chrome_path = '/usr/bin/chromium-browser'
  chrome_options.binary = chrome_path if File.exist?(chrome_path)

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.infer_spec_type_from_file_location!

  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
    Capybara.server = :puma, { Silent: true }
  end

  config.include Warden::Test::Helpers
  config.after(:each) { Warden.test_reset! }

  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include FactoryBot::Syntax::Methods

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!
end
