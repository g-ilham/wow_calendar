class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  expose(:valid_captcha) { false }
  expose(:user) { User.new }

  def new
  end

  def create
    build_resource(sign_up_params)

    if resource.valid?
      if verify_recaptcha
        success_captcha
      else
        not_valid_captcha_response
      end
    end
  end

  include Concerns::DeviseRequestValidation
  include Concerns::DeviseCreateRegistrationHelpers
end
