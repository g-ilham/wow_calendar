class ThemesController < ApplicationController
  layout :resolve_layout
  before_action :gritter_image_url
  before_action :gallery_image_urls, only: [ :gallery ]
  before_action :login_image_url, only: [ :login ]
  before_action :authenticate_user!

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
    @all_files = Dir.glob('app/assets/images/theme/portfolio/*.jpg')
    if @all_files
      @all_files = clean_image_url

      @all_images_urls = @all_files.map do |filename|
        get_image_url(filename)
      end
    end
  end

  def clean_image_url
    @all_files.map { |url| url.gsub('app/assets/images/', '') }
  end

  private

  def resolve_layout
    case action_name
    when 'login'
      'login'
    else
      'theme'
    end
  end
end
