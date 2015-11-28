class Users::SocialLogin::Base
  class << self
    def set_account!(user, provider, social_params)
      {
        user: save_user!(user, get_attrs(provider, social_params)),
        email: social_params.info.email.to_s
      }
    end

    def get_attrs(provider, social_params)
      attrs = provider == "vk" ? vk_attrs(social_params) : fb_attrs(social_params)
      attrs = extend_photo(attrs, social_params)
    end

    def extend_photo(attrs, social_params)
      img_url = social_params.info.image
      attrs[:remote_photo_url] = img_url if img_url.present?

      attrs
    end

    def save_user!(user, attrs)
      if user.present?
        user.update(attrs)
      else
        user = User.new(attrs)
        user.email = nil
        user.password = Devise.friendly_token[0,20]

        user.skip_confirmation!
        user.save!
      end

      user
    end
  end
end
