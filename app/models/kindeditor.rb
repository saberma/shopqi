#encoding: utf-8
#用于处理富文本编辑
class Kindeditor < ActiveRecord::Base
  belongs_to :shop
  attr_accessible :kindeditor_image

  image_accessor :kindeditor_image do
    storage_path{ |image|
      "#{self.shop.id}/kindeditors/#{image.basename}_#{rand(1000)}.#{image.format}" # data/shops/1/kindeditors/foo_45.jpg
    }
  end

  validates_size_of :kindeditor_image, maximum: 8000.kilobytes
  validates_with StorageValidator

  validates_property :mime_type, of: :kindeditor_image, in: %w(image/jpeg image/jpg image/png image/gif), message:  "格式不正确"

  def url
    "#{asset_host}#{kindeditor_image.url}"
  end
end
