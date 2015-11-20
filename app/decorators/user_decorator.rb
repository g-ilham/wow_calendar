class UserDecorator < Draper::Decorator
  def full_name
    if object.provider.present?
      if object.provider == 'vk'
        object.vkontakte_username
      else
        object.facebook_username
      end
    else
      object.first_name.to_s + object.last_name.to_s
    end
  end
end
