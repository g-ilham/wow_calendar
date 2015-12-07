class ThemesController < ApplicationController
  layout :resolve_layout

  expose(:login_image_url) do
    System::GetAssetFilesUrls.get_image_url('theme/login-bg.jpg')
  end

  expose(:gallery_images_urls) do
    asset_matcher = 'app/assets/images/'
    path = asset_matcher + 'theme/portfolio/*.jpg'
    System::GetAssetFilesUrls.new(asset_matcher, path, 'images').run
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

  def task_lists
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
