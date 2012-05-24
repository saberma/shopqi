# encoding: utf-8
class Tag < ActiveRecord::Base
  belongs_to :shop
  has_and_belongs_to_many :product
  attr_accessible :name, :category

  # 最近使用过的标签
  scope :previou_used, lambda{|c| where(category:c).order(:updated_at.desc)}

  # 分隔逗号
  def self.split(text)
    text ? text.split(/[,，]\s*/).uniq : []
  end
end
