class PhotoValidator < ActiveModel::Validator
  FILE_MAX_SIZE = 5.megabytes
  GEOMETRY_MAX_DIMENSION = 1500.0

  attr_accessor :record

  def validate(record)
    self.record = record

    validate_size!
    validate_geometry!
  end

  def validate_size!
    if record.photo.size.to_f > FILE_MAX_SIZE
      record.errors.add(:photo,
        I18n.t("errors.messages.max_size_error",
               max_size: "5 megabytes")
      )
    end
  end

  def validate_geometry!
    geometry = record.photo.geometry

    if geometry.present?
      width, height = geometry.map(&:to_f)

      if width > GEOMETRY_MAX_DIMENSION || height > GEOMETRY_MAX_DIMENSION
        record.errors.add(:photo,
          I18n.t("errors.messages.max_dimentions_error",
                  max_dementions: "#{GEOMETRY_MAX_DIMENSION}x#{GEOMETRY_MAX_DIMENSION}")
        )
      end
    end
  end
end
