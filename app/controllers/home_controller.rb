class HomeController < ApplicationController
  layout 'landing'

  expose(:skel_css_files) do
    SkelCssFilesUrls.new().paths
  end

  def index
  end
end
