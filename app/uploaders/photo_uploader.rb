class PhotoUploader < FileUploader
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url
    ActionController::Base.helpers.asset_path(
      "fallback/logo_default.png"
    )
  end

  version :thumb do
    process resize_to_fill: [60, 60]
  end
end
