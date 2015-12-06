# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  POSSIBLE_IMG_EXTENSIONS = %w(jpg jpeg gif png)

  def extension_white_list
    POSSIBLE_IMG_EXTENSIONS
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*)
    ActionController::Base.helpers.asset_url(
      "fallback/" + [version_name, "default.png"].compact.join('_')
    )
  end
end
