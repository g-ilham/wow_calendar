module Users
  class Login
    CHECKS = [
      'email_exsist?',
      'set_user',
      'user_is_found?',
      'password_param_is_valid?',
      'password_is_valid?',
      'is_confirmed?'
    ]

    attr_accessor :params,
                  :errors,
                  :user

    def initialize(params)
      self.params = params
      self.errors = {}
    end

    def success?
      params.present? && errors.blank?
    end

    def login_user!
      System::CallSomeMethods.call_in_methods(CHECKS, self, true)
    end

    private

    def password_param_is_valid?
      self.errors[:password] = I18n.t(:errors)[:messages][:empty] if params[:password].blank?
    end

    def email_exsist?
      self.errors[:email] = I18n.t(:errors)[:messages][:empty] if params[:email].blank?
    end

    def user_is_found?
      if user.blank?
        self.errors[:email] = I18n.t(:errors)[:messages][:invalid]
      end
    end

    def password_is_valid?
      self.errors[:password] = I18n.t(:errors)[:messages][:invalid] unless user.valid_password?(params[:password])
    end

    def is_confirmed?
      unless user.confirmed?
        self.errors[:email] = "#{User.human_attribute_name(:email)} не подтвержден"
      end
    end

    def set_user
      self.user = User.where(email: params[:email]).first
    end
  end
end
