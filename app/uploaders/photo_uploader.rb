class PhotoUploader < FileUploader

  attr_accessor :geometry

  process :set_geometry

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :thumb do
    process resize_to_fill: [60, 60]
  end

  protected

  def set_geometry
    manipulate! do |image|
      @geometry = [image.width, image.height]
      image
    end
  end
end
