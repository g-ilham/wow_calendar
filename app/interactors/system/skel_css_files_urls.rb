module System
  class SkelCssFilesUrls
    attr_accessor :paths,
                  :full_path,
                  :asset_matcher

    SORTED_NAMES = [
      'style',
      'xlg',
      'large',
      'medium',
      'small',
      'xsm'
    ]

    def initialize
      specify_base_vars
      self.paths = System::GetAssetFilesUrls.new(asset_matcher, full_path).run
      sort_css_paths
    end

    def specify_base_vars
      if Rails.env.development?
        self.full_path = 'app/assets/stylesheets/transit_theme/*.css.scss'
        self.asset_matcher = 'app/assets/stylesheets/'
      else
        self.full_path = 'public/assets/transit_theme/*.css'
        self.asset_matcher = 'public/'
      end
    end

    def sort_css_paths
      self.paths = SORTED_NAMES.map do |current_path|
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
