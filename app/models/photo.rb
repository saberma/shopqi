# encoding: utf-8
class Photo < ActiveRecord::Base
  belongs_to :product, inverse_of: "photos"

  image_accessor :product_image

  validates_size_of :product_image, maximum: 6000.kilobytes

  validates_property :mime_type, of: :product_image, in: %w(image/jpeg image/jpg image/png image/gif), message:  "请上传正确格式的图片"

  #定义图片显示大小种类
  def self.versions(opt={})
    opt.each_pair do |k,validates_property|
      define_method k do
        if product_image
          product_image.thumb(v)
        end
      end
    end
  end

  #显示在产品详情页中的缩略图(icon)
  # 显示在产品列表页中的缩略图(small)
  # 显示在产品详情页中的图片(middle)
  # 显示在产品详情页中的放大镜图片(big)
  versions icon:'60x60#', small:'175x175#', middle:'418x418#', big:'1024x1024#', accordion:'220x118#'
end
