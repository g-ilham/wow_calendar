class Users::SocialLogin::Vk < Users::SocialLogin::Base
  class << self
    def vk_attrs(social_params)
      {
        vkontakte_url: social_params.info.urls.Vkontakte,
        vkontakte_username: social_params.info.name,
        vkontakte_uid: social_params.uid,
        vkontakte_nickname: social_params.info.nickname,
        first_name: social_params.info.first_name,
        last_name:  social_params.info.last_name,
        provider: 'vk'
      }
    end

    def oauth(social_params)
      user = User.where(vkontakte_uid: social_params.uid).first
      set_account!(user, "vk", social_params)
    end
  end
end
