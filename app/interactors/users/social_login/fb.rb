class Users::SocialLogin::Fb < Users::SocialLogin::Base
  class << self
    def fb_attrs(social_params)
      {
        facebook_url: social_params.info.urls.Facebook,
        facebook_username: social_params.info.name,
        facebook_uid: social_params.uid,
        first_name: social_params.info.first_name,
        last_name:  social_params.info.last_name,
        provider: 'facebook'
      }
    end

    def oauth(social_params)
      user = User.where(facebook_uid: social_params.uid).first
      set_account!(user, "facebook", social_params)
    end
  end
end
