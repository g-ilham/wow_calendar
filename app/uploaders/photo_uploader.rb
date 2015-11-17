class PhotoUploader < FileUploader
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url
    ActionController::Base.helpers.asset_path(
      "fallback/logo_default.png"
    )
  end
end
