module Concerns
  module DeviseCreateRegistrationHelpers
    extend ActiveSupport::Concern

    private

    def success_captcha
      self.valid_captcha = true
      resource.save
      yield resource if block_given?
      if resource.persisted?
        persisted_resoucre_code
      else
        resource_blank_response
      end
    end

    def not_valid_captcha_response
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      respond_with resource, location: after_inactive_sign_up_path_for(resource) do |format|
        format.js
      end
    end

    def persisted_resoucre_code
      if resource.active_for_authentication?
        active_authentication
      else
        not_active_authentication
      end
    end

    def resource_blank_response
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource do |format|
        format.js
      end
    end

    def active_authentication
      set_flash_message :notice, :signed_up if is_flashing_format?
      sign_up(resource_name, resource)
      respond_with resource, location: after_sign_up_path_for(resource)do |format|
        format.js
      end
    end

    def not_active_authentication
      set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
      expire_data_after_sign_in!
      respond_with resource, location: after_inactive_sign_up_path_for(resource) do |format|
        format.js
      end
    end
  end
end
