# encoding: utf-8
class LinkList < ActiveRecord::Base
  belongs_to :shop
  has_many :links, dependent: :destroy, order: :position.asc

  accepts_nested_attributes_for :links

  before_save do
    self.title = self.title.blank? ? '未命名' : self.title
    self.handle = Pinyin.t(self.title, '-') if self.handle.blank?
  end
end

class Link < ActiveRecord::Base
  belongs_to :link_list

  before_save do
    self.title = self.title.blank? ? '未命名' : self.title
  end
end
