class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :lockable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
end
