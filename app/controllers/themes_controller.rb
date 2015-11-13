class ThemesController < ApplicationController
  layout :resolve_layout
  before_action :gritter_image_url
  before_action :gallery_image_urls, only: [ :gallery ]
  before_action :login_image_url, only: [ :login ]

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

  def gritter_image_url
    @gritter_image_url = get_image_url('theme/ui-sam.jpg')
  end

  def login_image_url
    @login_image_url = get_image_url('theme/login-bg.jpg')
  end

  def get_image_url(url)
    ActionController::Base.helpers.image_path(url)
  end

  def gallery_image_urls
    @asset_matcher = 'app/assets/images/'
    get_asset_files_urls('app/assets/images/theme/portfolio/*.jpg', 'images')
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
