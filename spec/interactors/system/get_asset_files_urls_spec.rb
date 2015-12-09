require "rails_helper"

describe System::GetAssetFilesUrls do
  describe "will return the file paths assets" do
    let(:asset_matcher) { 'app/assets/images/' }
    let(:path) { asset_matcher + 'theme/portfolio/*.jpg' }
    let(:response_array) { ["/assets/theme/portfolio/port01.jpg",
                            "/assets/theme/portfolio/port02.jpg",
                            "/assets/theme/portfolio/port03.jpg",
                            "/assets/theme/portfolio/port04.jpg",
                            "/assets/theme/portfolio/port05.jpg",
                            "/assets/theme/portfolio/port06.jpg"]
                          }

    subject do
      System::GetAssetFilesUrls.new(asset_matcher, path, 'images').run
    end

    it "compares return" do
      expect(subject).to match_array(response_array)
    end
  end
end
