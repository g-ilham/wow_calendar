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
    in_hour true

    trait :fc_user do
      facebook_url "https://www.facebook.com/ilham116r"
      facebook_username "Ильхам Гайсин"
      facebook_uid "1234567"
      provider "facebook"
    end

    trait :vk_user do
      vkontakte_url "http://vk.com/id175788375"
      vkontakte_username "Ilham Gaysin"
      vkontakte_uid "12345678"
      vkontakte_nickname "ilgam"
      provider "vk"
    end
  end

  factory :event do
    association :user
    title "Встреча с одноклассниками"
    starts_at (Time.zone.now + 2.hour)
    ends_at (Time.zone.now + 4.hour)
    all_day false
    repeat_type 'not_repeat'

    trait :repeated_every_week do
      repeat_type "every_week"
    end

    trait :repeated_every_day do
      repeat_type "every_day"
      starts_at (Time.zone.now + 5.minute)
      ends_at (Time.zone.now + 4.hour)
    end
  end
end
