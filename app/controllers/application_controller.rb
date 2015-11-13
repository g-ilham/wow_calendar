class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def get_asset_files_urls(path, type='assets')
    @all_files = Dir.glob(path)

    if @all_files
      @all_files = clean_assets_urls
      @all_files = @all_files.map do |filename|
        get_asset_url(filename, type)
      end
    end
  end

  def clean_assets_urls
    @all_files.map { |url| url.gsub(@asset_matcher, '') }
  end

  def get_asset_url(url, type)
    if type == 'images'
      ActionController::Base.helpers.image_path(url)
    else
      ActionController::Base.helpers.asset_path(url)
    end
  end
end
