class Devise::OmniauthCallbacksController < DeviseController
  protect_from_forgery only: []
  prepend_before_filter { request.env["devise.skip_timeout"] = true }

  expose(:vk_user) do
    User.find_for_vkontakte_oauth request.env["omniauth.auth"]
  end

  expose(:fc_user) do
    User.find_for_facebook_oauth request.env["omniauth.auth"]
  end

  def vkontakte
    authorization_handler vk_user
  end

  def facebook
    authorization_handler fc_user
  end

  def passthru
    render status: 404, text: "Not found. Authentication passthru."
  end

  def failure
    set_flash_message :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    redirect_to after_omniauth_failure_path_for(resource_name)
  end

  protected

  def authorization_handler user
    if user.persisted?
      sign_in_and_redirect user, event: :authentication
    else
      redirect_to root_path
    end
  end

  def failed_strategy
    env["omniauth.error.strategy"]
  end

  def failure_message
    exception = env["omniauth.error"]
    error   = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.error        if exception.respond_to?(:error)
    error ||= env["omniauth.error.type"].to_s
    error.to_s.humanize if error
  end

  def after_omniauth_failure_path_for(scope)
    new_session_path(scope)
  end

  def translation_scope
    'devise.omniauth_callbacks'
  end
end
