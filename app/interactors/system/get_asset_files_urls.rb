module System
  class GetAssetFilesUrls

    attr_accessor :paths,
                  :asset_matcher,
                  :path,
                  :type

    def initialize(asset_matcher, path, type='assets')
      self.asset_matcher = asset_matcher
      self.path = path
      self.type = type
    end

    def run
      self.paths = Dir.glob(path)

      self.paths = if paths
        clean_assets_urls.map do |current_path|
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
