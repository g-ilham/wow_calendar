require "rails_helper"

describe System::GetAssetFilesUrls do
  describe "will return the file paths assets" do
    let(:asset_matcher) { 'app/assets/images/' }
    let(:path) { asset_matcher + 'theme/portfolio/*.jpg' }
    let(:response_array) { ["/assets/theme/portfolio/port01",
                            "/assets/theme/portfolio/port02",
                            "/assets/theme/portfolio/port03",
                            "/assets/theme/portfolio/port04",
                            "/assets/theme/portfolio/port05",
                            "/assets/theme/portfolio/port06"].sort
                          }

    subject do
      System::GetAssetFilesUrls.new(asset_matcher, path, 'images').run.sort
    end

    it "compares return" do
      expect(all_url_matched?).to be_truthy
    end

    def all_url_matched?
      res= subject.each_with_index.map do |url, index|
        url.include? response_array[index]
      end.all?(&:present?)
    end
  end
end
