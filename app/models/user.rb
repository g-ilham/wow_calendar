class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  begin :validations
    validates :first_name, :last_name,
      length: { minimum: 2, maximum: 100 },
      format: { with: /[а-яА-Яa-zA-Z]+/ },
      allow_nil: true,
      allow_blank: true
  end
end
