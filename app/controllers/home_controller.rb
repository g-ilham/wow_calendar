class HomeController < ApplicationController
  layout 'landing'
  before_action :page_images_urls

  def index
  end

  private

  def page_images_urls
    @asset_matcher = 'app/assets/stylesheets/'
    get_asset_files_urls('app/assets/stylesheets/transit_theme/*.css')
    sort_css_paths
  end

  def sorted_names
    [
      'style',
      'xlarge',
      'large',
      'medium',
      'small',
      'xsmall'
    ]
  end

  def sort_css_paths
    @all_files = sorted_names.each_with_index.map do |current_path, index|
      match = select_with_current(current_path)
      if match
        match
      end
    end.flatten.uniq
  end

  def select_with_current(current_path)
    @all_files.select { |path| path.include?(current_path) }
  end
end
