class HomeController < ApplicationController
  layout 'landing'

  expose(:skel_css_files) do
    System::SkelCssFilesUrls.new().paths
  end

  def index
  end
end
