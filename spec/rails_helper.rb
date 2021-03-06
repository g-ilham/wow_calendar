ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'shoulda/matchers'
require "capybara-screenshot/rspec" #screenshot_and_open_image

if ENV["CI"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

Capybara.javascript_driver = :webkit
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending!
ActiveRecord::Migration.maintain_test_schema!
WowCalendar::Application.load_tasks
Capybara::Screenshot.webkit_options = { width: 1024, height: 768 }
Capybara::Screenshot.autosave_on_failure = false

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include ExpectationHelper, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature
  config.include RemoveAnimation, type: :feature
  config.include DateTimeHelpers, type: :feature
  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include OmniauthMacros, type: :controller

  config.before :suite do
    Warden.test_mode!
  end

  config.after :each do
    Warden.test_reset!
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end

    DatabaseCleaner.start
    Sidekiq::Worker.clear_all
  end

  config.after do
    DatabaseCleaner.clean
  end

  Capybara::Webkit.configure do |config|
    config.block_unknown_urls
  end

  config.infer_spec_type_from_file_location!
end
