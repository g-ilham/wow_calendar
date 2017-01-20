class Users::SessionsController < Devise::SessionsController
  respond_to :js
  skip_before_action :social_registration!

  expose(:login) do
    Users::Login.new(params[:user])
  end

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
  end

  def create
    login.login_user!

    if !login.success?
      self.resource = resource_class.new(sign_in_params)
    else
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
    end
  end
end
