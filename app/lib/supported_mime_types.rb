module SupportedMimeTypes
  def self.image_types
    Mime::LOOKUP.filter { |k, v| is_image_mime_type?(v) }.values
  end

  def self.image_extensions
    Mime::EXTENSION_LOOKUP.filter { |k, v| is_image_mime_type?(v) }.keys
  end

  def self.video_types
    Mime::LOOKUP.filter { |k, v| is_video_mime_type?(v) }.values
  end

  def self.video_extensions
    Mime::EXTENSION_LOOKUP.filter { |k, v| is_video_mime_type?(v) }.keys
  end

  def self.document_types
    Mime::LOOKUP.filter { |k, v| is_document_mime_type?(v) }.values
  end

  def self.document_extensions
    Mime::EXTENSION_LOOKUP.filter { |k, v| is_document_mime_type?(v) }.keys
  end

  def self.archive_types
    Mime::LOOKUP.filter { |k, v| is_archive_mime_type?(v) }.values
  end

  def self.archive_extensions
    Mime::EXTENSION_LOOKUP.filter { |k, v| is_archive_mime_type?(v) }.keys
  end

  def self.model_types
    Mime::LOOKUP.filter { |k, v| is_model_mime_type?(v) }.values
  end

  def self.model_extensions
    Mime::EXTENSION_LOOKUP.filter { |k, v| is_model_mime_type?(v) }.keys
  end

  def self.can_export?(type)
    [:threemf].include? type
  end

  def self.indexable_types
    image_types + model_types + video_types + document_types + archive_types
  end

  def self.indexable_extensions
    image_extensions + model_extensions + video_extensions + document_extensions + archive_extensions
  end

  class << self
    private

    def is_image_mime_type?(type)
      exclusions = [
        "image/vnd.dxf",
        "image/vnd.dwg"
      ]
      type.to_s.start_with?("image/") && exclusions.exclude?(type.to_s)
    end

    def is_video_mime_type?(type)
      type.to_s.start_with?("video/")
    end

    def is_document_mime_type?(type)
      [
        "application/pdf",
        "text/markdown",
        "text/plain",
        "text/html",
        "application/msword",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      ].include?(type.to_s)
    end

    def is_model_mime_type?(type)
      extras = [
        "text/x-gcode",
        "application/x-openscad",
        "image/vnd.dxf",
        "image/vnd.dwg",
        "application/x-3ds",
        "application/x-amf"
      ]
      type.to_s.start_with?("model/") || extras.include?(type.to_s)
    end

    def is_archive_mime_type?(type)
      [
        "application/zip",
        "application/gzip",
        "application/vnd.rar",
        "application/x-7z-compressed",
        "application/x-bzip2"
      ].include?(type.to_s)
    end
  end
end
