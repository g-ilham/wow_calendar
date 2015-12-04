class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  mount_uploader :photo, PhotoUploader

  NAME_REGEXP = /\A[а-яА-Яa-zA-Z0-9\s]+\z/

  begin :validations
    validates :first_name, :last_name,
      length: { minimum: 2, maximum: 100 },
      format: { with: NAME_REGEXP },
      allow_nil: true,
      allow_blank: true
    validates_with PhotoValidator, if: 'self.photo?'
  end

  begin :associations
    has_many :events, dependent: :destroy
  end

  begin :callbacks
    before_validation :trim_name
  end

  def trim_name
    self.first_name = self.first_name.strip() if first_name
    self.last_name = self.last_name.strip() if last_name
  end

  def email_registration?
    vkontakte_uid.blank? && facebook_uid.blank?
  end

  def email_required?
    super && email_registration?
  end

  def notifications_options
    [
      in_fifteen_minutes,
      in_hour,
      in_day
    ]
  end
end
