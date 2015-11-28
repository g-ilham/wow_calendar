class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  expose(:vk_user) do
    Users::SocialLogin::Vk.oauth(request.env["omniauth.auth"])
  end

  expose(:fc_user) do
    Users::SocialLogin::Fb.oauth(request.env["omniauth.auth"])
  end

  def vkontakte
    authorization_handler(vk_user)
  end

  def facebook
    authorization_handler(fc_user)
  end

  protected

  def authorization_handler params
    if params[:user].email.present?
      sign_in_and_redirect params[:user], event: :authentication
    else
      sign_in(:user, params[:user])
      redirect_to complete_social_registration_form_path(user: { email: params[:email] })
    end
  end
end
