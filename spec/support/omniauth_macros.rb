module OmniauthMacros
  def fc_mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = Hashie::Mash.new({
      :provider => 'facebook',
      :uid => '1234567',
      :info => {
        :email => 'ilgamgaysin@gmail.com',
        :name => 'Ильхам Гайсин',
        :first_name => 'Ильхам',
        :last_name => 'Гайсин',
        :urls => { :Facebook => 'https://www.facebook.com/ilham116r' },
        :verified => true
      }
    })
  end

  def vk_mock_auth_hash
    OmniAuth.config.mock_auth[:vkontakte] = Hashie::Mash.new({
      :provider => "vkontakte",
      :uid => "12345678",
      :info => {
        :email => "ilgamgaysin@gmail.com",
        :name => "Ильхам Гайсин",
        :nickname => "ilgam",
        :first_name => "Ильхам",
        :last_name => "Гайсин",
        :urls => {
          :Vkontakte => "http://vk.com/id175788375"
        }
      }
    })
  end

  private

  def generate_request_in_callback(provider)
    request.env["devise.mapping"] = Devise.mappings[:user]
    omniauth_data(provider)
    get provider.to_sym
  end

  def omniauth_data(provider)
    request.env["omniauth.auth"] = if provider == 'facebook'
      fc_mock_auth_hash
    else
      vk_mock_auth_hash
    end
  end
end
