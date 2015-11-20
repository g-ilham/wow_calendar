class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  mount_uploader :photo, PhotoUploader

  has_many :events, dependent: :destroy

  begin :validations
    validates :first_name, :last_name,
      length: { minimum: 2, maximum: 100 },
      format: { with: /[а-яА-Яa-zA-Z]+/ },
      allow_nil: true,
      allow_blank: true
    validates :email, presence: true
    validate :image_size_validation
    validate :image_geometry_validation
    validate :image_mime_type_validation
  end

  def image_size_validation
    if photo.size.to_f > 1.megabytes
      errors.add(:photo, I18n.t("errors.messages.max_size_error",
                                  max_size: '10мб'))
    end
  end

  def image_mime_type_validation
    type = photo.content_type.to_s

    if !(/(\.|\/)(gif|jpeg|jpg|png)$/i).match(type).present?
      errors.add(:mime_type, "не верно")
    end
  end

  def image_geometry_validation
    if photo.geometry

      width, height = photo.geometry.map(&:to_f)
      if width > 200.0 || height > 200.0
        errors.add(:photo, I18n.t("errors.messages.max_dimentions_error",
                                    max_dementions: "200x200"))
      end
    end
  end

  def email_required?
    super && vkontakte_uid.blank? && facebook_uid.blank?
  end

  class << self
    #TODO need refator

    def vk_attrs social_params
      {
        vkontakte_url: social_params.info.urls.Vkontakte,
        vkontakte_username: social_params.info.name,
        vkontakte_uid: social_params.uid,
        vkontakte_nickname: social_params.info.nickname,
        first_name: social_params.info.first_name,
        last_name:  social_params.info.last_name,
        provider: 'vk'
      }
    end

    def facebook_attrs social_params
      {
        facebook_url: social_params.info.urls.Facebook,
        facebook_username: social_params.info.name,
        facebook_uid: social_params.uid,
        first_name: social_params.info.first_name,
        last_name:  social_params.info.last_name,
        provider: 'facebook'
      }
    end

    def find_for_vkontakte_oauth social_params
      user = User.where(vkontakte_uid: social_params.uid).first
      create_or_update_social_account!(user, "vk", social_params)
    end

    def find_for_facebook_oauth social_params
      user = User.where(facebook_uid: social_params.uid).first
      create_or_update_social_account!(user, "facebook", social_params)
    end

    def create_or_update_social_account!(user, provider, social_params)
      {
        user: save_user!(user, get_attrs(provider, social_params)),
        email: social_params.info.email.to_s
      }
    end

    def get_attrs(provider, social_params)
      attrs = if provider == "vk"
        vk_attrs(social_params)
      else
        facebook_attrs(social_params)
      end
      attrs = extend_photo(attrs, social_params)
    end

    def save_user!(user, attrs)
      if user.present?
        user.update(attrs)
      else
        user = User.new(attrs)
        user.email = nil
        user.password = Devise.friendly_token[0,20]

        user.skip_confirmation!
        user.save!(validate: false)
      end
      user
    end

    def extend_photo(attrs, social_params)
      img_url = social_params.info.image
      if img_url.present?
        attrs[:remote_photo_url] = img_url
        attrs
      else
        attrs
      end
    end
  end
end
