class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  before_action :html?, only: [ :new, :create ]

  expose(:valid_captcha) { false }
  expose(:user) { User.new }

  def new
  end

  def create
    build_resource(sign_up_params)

    if resource.valid?
      if verify_recaptcha
        self.valid_captcha = true
        resource.save
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_flashing_format?
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)do |format|
              format.js
            end
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource) do |format|
              format.js
            end
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource do |format|
            format.js
          end
        end
      else
        build_resource(sign_up_params)
        clean_up_passwords(resource)
        respond_with resource, location: after_inactive_sign_up_path_for(resource) do |format|
          format.js
        end
      end
    end
  end

  def html?
    if request.format.html?
      redirect_to root_path
      return
    end
  end
end
