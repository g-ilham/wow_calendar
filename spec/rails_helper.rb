ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'shoulda/matchers'
require "capybara-screenshot/rspec"

Capybara.javascript_driver = :webkit
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending!
ActiveRecord::Migration.maintain_test_schema!
WowCalendar::Application.load_tasks
Capybara::Screenshot.webkit_options = { width: 1024, height: 768 }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include ExpectationHelper, type: :feature
  config.include Devise::TestHelpers, type: :controller

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.raise_error_for_unimplemented_steps = true
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
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
end
