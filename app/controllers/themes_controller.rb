class ThemesController < ApplicationController
  layout 'theme'
  before_action :gritter_image_url

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

  def gritter_image_url
    @gritter_url = ActionController::Base.helpers.image_path('theme/ui-sam.jpg')
  end
end
