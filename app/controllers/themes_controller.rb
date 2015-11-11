class ThemesController < ApplicationController
  layout 'theme'
  before_action :popover_image_url

  def dashboard
  end

  def blank
  end

  def popover_image_url
    @popover_url = ActionController::Base.helpers.image_path('theme/ui-sam.jpg')
  end
end
