module System
  class SkelCssFilesUrls

    attr_reader :paths

    SORTED_NAMES =  [
                      'style',
                      'xlarge',
                      'large',
                      'medium',
                      'small',
                      'xsmall'
                    ]

    def initialize
      asset_matcher = 'app/assets/stylesheets/'
      path = asset_matcher + 'transit_theme/*.css.scss'
      @paths = System::GetAssetFilesUrls.new(asset_matcher, path).paths
      sort_css_paths if paths
    end

    def sort_css_paths
      @paths = SORTED_NAMES.map do |current_path|
        match = select_with_current(current_path)
        if match
          match
        end
      end.flatten.uniq
    end

    def select_with_current(current_path)
      paths.select { |path| path.include?(current_path) }
    end
  end
end
