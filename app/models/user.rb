class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  mount_uploader :photo, PhotoUploader

  begin :validations
    validates :first_name, :last_name,
      length: { minimum: 2, maximum: 100 },
      format: { with: /[а-яА-Яa-zA-Z]+/ },
      allow_nil: true,
      allow_blank: true
  end

  def email_required?
    super && vkontakte_uid.blank? && facebook_uid.blank?
  end

  class << self

    def vk_attrs social_params
      {
        vkontakte_url: social_params.info.urls.Vkontakte,
        vkontakte_username: social_params.info.name,
        vkontakte_uid: social_params.uid,
        vkontakte_nickname: social_params.info.nickname,
        first_name: social_params.info.first_name,
        last_name:  social_params.info.last_name
      }
    end

    def facebook_attrs social_params
      {
        facebook_url: social_params.info.urls.Facebook,
        facebook_username: social_params.info.name,
        facebook_uid: social_params.uid,
        first_name: social_params.info.first_name,
        last_name:  social_params.info.last_name
      }
    end

    def find_for_vkontakte_oauth social_params
      user = User.where(vkontakte_uid: social_params.uid).first
      create_or_update_social_account!(user, "vk", social_params)
    end

    def find_for_facebook_oauth social_params
      user = User.where(facebook_uid: social_params.uid).first
      create_or_update_social_account!(user, "facebook", social_params)
    end

    def create_or_update_social_account!(user, provider, social_params)
      attrs = if provider == "vk"
        vk_attrs(social_params)
      else
        facebook_attrs(social_params)
      end
      attrs = extend_photo(attrs, social_params)

      if user.present?
        user.update(attrs)
      else
        user = User.new(attrs)
        user.password = Devise.friendly_token[0,20]

        user.skip_confirmation!

        user.save!
      end

      user
    end

    def extend_photo(attrs, social_params)
      img_url = social_params.info.image
      if img_url.present?
        attrs[:remote_photo_url] = img_url
        attrs
      else
        attrs
      end
    end
  end
end
