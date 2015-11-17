module Users
  class UserLogin

    attr_reader :params,
                :errors,
                :user

    METHODS = [
                'email_exsist?',
                'set_user',
                'user_is_found?',
                'password_param_is_valid?',
                'password_is_valid?',
                'is_confirmed?'
              ]

    def initialize(params)
      if params
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
      System::CallSomeMethods.call_in_methods(METHODS, self, true)
    end

    def password_param_is_valid?
      @errors[:password] = blank_message if params[:password].blank?
    end

    def email_exsist?
      @errors[:email] = blank_message if params[:email].blank?
    end

    def user_is_found?
      if user.blank?
        @errors[:email] = "пользователь не найден"
        @errors[:password] = "пароль неверен"
      end
    end

    def password_is_valid?
      @errors[:password] = "пароль неверен" unless user.valid_password?(params[:password])
    end

    def is_confirmed?
      @errors[:email] = "Почтовый адрес не подтвержден" unless user.confirmed?
    end

    def set_user
      @user = User.where(email: params[:email]).first
    end
  end
end