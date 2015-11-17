Recaptcha.configure do |config|
  config.public_key  = ENV['WOWCALENDAR_RECAPTCHA_PUBLIC_KEY']
  config.private_key = ENV['WOWCALENDAR_RECAPTCHA_PRIVATE_KEY']
  config.api_version = 'v2'
end
