class Users::RegistrationsController < Devise::RegistrationsController
  include Concerns::DeviseRequestValidation
  respond_to :js

  before_action :configure_permitted_parameters, if: :devise_controller?

  prepend_before_action :check_captcha, only: %i(create)

  private
    def check_captcha
      @verified_recaptcha = verify_recaptcha

      unless @verified_recaptcha
        self.resource = resource_class.new sign_up_params
        respond_with_navigational(resource)
      end
    end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
