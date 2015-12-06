module System
  class GetAssetFilesUrls

    attr_reader :paths,
                :asset_matcher,
                :path,
                :type

    SORTED_NAMES = [
      'style',
      'xlarge',
      'large',
      'medium',
      'small',
      'xsmall'
    ]

    def initialize(asset_matcher, path, type='assets')
      @asset_matcher = asset_matcher
      @path = path
      @type = type
      run
    end

    def run
      @paths = Dir.glob(path)

      @paths = if paths
        @paths = clean_assets_urls
        paths.map do |current_path|
          get_asset_url(current_path)
        end
      end
    end

    def clean_assets_urls
      paths.map { |url| url.gsub(asset_matcher, '') }
    end

    def get_asset_url(current_path)
      if type == 'images'
        self.class.get_image_url(current_path)
      else
        ActionController::Base.helpers.asset_path(current_path)
      end
    end

    class << self
      def get_image_url(url)
        ActionController::Base.helpers.image_path(url)
      end
    end
  end
end
