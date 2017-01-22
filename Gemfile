source "https://rubygems.org"
ruby "2.2.3"

gem "rails", "4.2.7.1"
gem "pg", "~> 0.18.3"
gem "devise", ">= 3.5.4"

# Assets and UI
gem "bootstrap-sass"
gem "sass-rails"
gem "uglifier"
gem "coffee-rails"
gem "therubyracer", platforms: :ruby
gem "jquery-rails"
gem "jquery-ui-rails"
gem "slim-rails"
gem "font-awesome-rails"
gem "simple_form"
gem "fancybox2-rails", "~> 0.2.8"

# JSON handlers
gem "active_model_serializers"

# Localization
gem "russian"

# Plugins
gem "recaptcha", "~> 0.4.0"
gem "validates_timeliness", "~> 3.0"
gem "momentjs-rails", ">= 2.9.0"
gem "bootstrap3-datetimepicker-rails", "~> 4.14.30"
gem "email_validator"
gem "activerecord_any_of"
gem "coveralls", require: false

# Social Providers
gem "omniauth"
gem "omniauth-vkontakte"
gem "omniauth-facebook"

# File Uploads
gem "carrierwave"
gem "fog"
gem "fog-aws"
gem "mini_magick"
# Rails4 file_fieId Can"t verify CSRF token authenticity
# https://github.com/rails/jquery-ujs/issues/331
gem "remotipart", "~> 1.2"

# Exposing && Decorator
gem "decent_exposure"
gem "draper"

# Background Jobs
gem "sidekiq"
gem "sidekiq-status"
gem "sinatra", require: false

# Enviroment variables and Server Stuff
gem "dotenv-rails"
gem "foreman"

# db population
gem "faker"

group :development, :test do
  gem "pry-rails"
  gem "quiet_assets"
  gem "better_errors"
  gem "letter_opener"
  gem "byebug"
  gem "rails_best_practices"
end

group :test do
  gem "capybara"
  gem "capybara-webkit"
  gem "capybara-screenshot"
  gem "database_cleaner"
  gem "launchy"
  gem "rspec-rails"
  gem "shoulda-matchers", require: false
  gem "timecop"
  gem "factory_girl_rails"
  gem "rspec-sidekiq"
  gem "hashie"
  gem "codeclimate-test-reporter", "~> 0.6.0", require: false
end

gem "rails_12factor", group: :production
