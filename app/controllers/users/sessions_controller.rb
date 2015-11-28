class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json
  before_action :html?, only: [ :new, :create ]

  expose(:login) do
    Users::UserLogin.new(params[:user])
  end

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
  end

  def create
    if login.errors.present?
      @user = User.new if login.user.blank?

    else
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
      yield resource if block_given?
    end
  end

  def html?
    if request.format.html?
      redirect_to root_path
      return
    end
  end
end
