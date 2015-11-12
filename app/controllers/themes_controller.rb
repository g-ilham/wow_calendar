class ThemesController < ApplicationController
  layout 'theme'
  before_action :gritter_image_url
  before_action :gallery_image_urls, only: [ :gallery ]

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

  def gritter_image_url
    @gritter_url = ActionController::Base.helpers.image_path('theme/ui-sam.jpg')
  end

  def gallery_image_urls
    @all_files = Dir.glob('app/assets/images/theme/portfolio/*.jpg')
    if @all_files
      @all_files = clean_image_url

      @all_images_urls = @all_files.map do |filename|
        ActionController::Base.helpers.image_path(filename)
      end
    end
  end

  def clean_image_url
    @all_files.map { |url| url.gsub('app/assets/images/', '') }
  end
end
