# encoding: utf-8
class Tag < ActiveRecord::Base
  belongs_to :shop
  has_and_belongs_to_many :product

  # 最近使用过的标签
  def self.previou_used
    order(:updated_at.desc)
  end

  # 分隔逗号
  def self.split(text)
    text ? text.split(/[,，]\s*/).uniq : []
  end
end
