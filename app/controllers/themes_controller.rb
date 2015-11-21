class ThemesController < ApplicationController
  layout :resolve_layout

  expose(:login_image_url) do
    System::GetAssetFilesUrls.get_image_url('theme/login-bg.jpg')
  end

  expose(:gallery_images_urls) do
    path = 'app/assets/images/theme/portfolio/*.jpg'
    asset_matcher = 'app/assets/images/'
    System::GetAssetFilesUrls.new(asset_matcher, path, 'images').paths
  end

  def index
  end

  def blank
  end

  def general
  end

  def buttons
  end

  def panels
  end

  def calendar
  end

  def gallery
  end

  def todos
  end

  def login
  end

  def basic_tables
  end

  def responsive_tables
  end

  def form_components
  end

  def get_image_url(url)
    ActionController::Base.helpers.image_path(url)
  end

  private

  def resolve_layout
    case action_name
    when 'login'
      'theme_login'
    else
      'theme'
    end
  end
end
