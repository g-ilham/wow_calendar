# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:email) { |n| "test_user#{n}@example.com" }
  sequence(:vk_url, 400) { |n| "http://vk.com/id175788#{n}" }
  sequence(:fc_url, 100) { |n| "https://www.facebook.com/ilham#{n}" }
  sequence(:uid) { |n| n.to_s }

  factory :user do
    first_name "Ivan"
    last_name "Ivanov"
    email { generate :email }
    password Devise.friendly_token[0,20]
    confirmed_at Time.zone.now
    photo { Rack::Test::UploadedFile.new(File.join(Rails.root,
            'spec', 'support', 'images', 'test_user_photo.jpg')) }
    in_hour true

    trait :fc_user do
      facebook_url { generate :fc_url }
      facebook_username Faker::Name.name
      facebook_uid { generate :uid }
      provider "facebook"
    end

    trait :vk_user do
      vkontakte_url { generate :vk_url }
      vkontakte_username Faker::Name.name
      vkontakte_uid { generate :uid }
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
