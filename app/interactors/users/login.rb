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

    attr_reader :params,
                :errors,
                :user

    def initialize(params)
      if params.present?
        @params = params
        @errors = {}

        login_user!
      end
    end

    def blank_message
      "не может быть пустым"
    end

    private

    def login_user!
      System::CallSomeCHECKS.call_in_methods(CHECKS, self, true)
    end

    def password_param_is_valid?
      @errors[:password] = blank_message if params[:password].blank?
    end

    def email_exsist?
      @errors[:email] = blank_message if params[:email].blank?
    end

    def user_is_found?
      if user.blank?
        @errors[:email] = "почтовый адрес неверен"
        @errors[:password] = "пароль неверен"
      end
    end

    def password_is_valid?
      @errors[:password] = "пароль неверен" unless user.valid_password?(params[:password])
    end

    def is_confirmed?
      @errors[:email] = "почтовый адрес не подтвержден" unless user.confirmed?
    end

    def set_user
      @user = User.where(email: params[:email]).first
    end
  end
end
