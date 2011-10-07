# encoding: utf-8
# 主题商店列表页面的主题截图
class ThemeMainUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "s/theme/screenshots/#{model.id}/#{mounted_as}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :featured do
    process :resize_to_fill => [285, 366]
  end

  version :signup do
    process :resize_to_fill => [198, 254]
  end

  version :large do
    process :resize_to_fill => [380, 488]
  end

  version :medium do
    process :resize_to_fill => [205, 263]
  end

  version :large do
    process :resize_to_fill => [380, 488]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename # 500x642
    "original.jpg" if original_filename
  end

end
