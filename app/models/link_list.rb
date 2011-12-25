# encoding: utf-8
class LinkList < ActiveRecord::Base
  include Models::Handle
  belongs_to :shop
  has_many :links, dependent: :destroy, order: :position.asc

  accepts_nested_attributes_for :links

  before_save do
    self.title = self.title.blank? ? '未命名' : self.title
    self.make_valid(shop.link_lists)
  end
end

class Link < ActiveRecord::Base
  belongs_to :link_list

  before_save do
    self.title = self.title.blank? ? '未命名' : self.title
  end
end
