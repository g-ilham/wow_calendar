# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:email) { |n| "test_user#{n}@example.com" }

  factory :user do
    first_name "Ivan"
    last_name "Ivanov"
    email "test@example.com"
    password Devise.friendly_token[0,20]
    confirmed_at DateTime.now
    photo { Rack::Test::UploadedFile.new(File.join(Rails.root,
            'spec', 'support', 'images', 'test_user_photo.jpg')) }
  end
end
