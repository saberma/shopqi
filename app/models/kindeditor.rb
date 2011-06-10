#encoding: utf-8
#用于处理富文本编辑
class Kindeditor < ActiveRecord::Base
  image_accessor :kindeditor_image

  validates_size_of :kindeditor_image, maximum: 8000.kilobytes

  validates_property :mime_type, of: :kindeditor_image, in: %w(image/jpeg image/jpg image/png image/gif), message:  "格式不正确"
end
