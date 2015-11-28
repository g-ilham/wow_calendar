class UserDecorator < Draper::Decorator
  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def provider_full_name
    object.provider.present? ? provider_user_name : full_name
  end

  def provider_user_name
    object.provider == 'vk' ? object.vkontakte_username : object.facebook_username
  end

  def name_or_email
    object.first_name || object.email
  end
end
