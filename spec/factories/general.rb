# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:email) { |n| "test_user#{n}@example.com" }

  factory :user do
    first_name "Ivan"
    last_name "Ivanov"
    email "test@example.com"
    password Devise.friendly_token[0,20]
    confirmed_at Time.zone.now
    photo { Rack::Test::UploadedFile.new(File.join(Rails.root,
            'spec', 'support', 'images', 'test_user_photo.jpg')) }
  end

  factory :event do
    association :user
    title "Встреча с одноклассниками"
    starts_at (Time.zone.now + 1.hour)
    ends_at (Time.zone.now + 4.hour)
    repeat_type 'not_repeat'
  end
end
