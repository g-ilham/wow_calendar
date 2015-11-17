# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  storage :file
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
