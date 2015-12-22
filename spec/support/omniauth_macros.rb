module OmniauthMacros
  def fc_mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = Hashie::Mash.new({
      :provider => 'facebook',
      :uid => uid,
      :info => {
        :email => generate(:email),
        :name => 'Ильхам Гайсин',
        :first_name => 'Ильхам',
        :last_name => 'Гайсин',
        :urls => { :Facebook => generate(:fc_url) },
        :verified => true
      }
    })
  end

  def vk_mock_auth_hash
    OmniAuth.config.mock_auth[:vkontakte] = Hashie::Mash.new({
      :provider => "vkontakte",
      :uid => uid,
      :info => {
        :email => generate(:email),
        :name => "Ильхам Гайсин",
        :first_name => "Ильхам",
        :last_name => "Гайсин",
        :urls => {
          :Vkontakte => generate(:vk_url)
        }
      }
    })
  end

  private

  def generate_request_in_callback
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = mock_auth_hash
    get mock_auth_hash.provider.to_sym
  end
end
