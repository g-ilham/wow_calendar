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
end
