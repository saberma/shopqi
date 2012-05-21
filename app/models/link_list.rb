# encoding: utf-8
class LinkList < ActiveRecord::Base
  include Models::Handle
  belongs_to :shop
  has_many :links, dependent: :destroy, order: :position.asc
  attr_accessible :title, :handle, :system_default

  accepts_nested_attributes_for :links

  before_save do
    self.title = self.title.blank? ? '未命名' : self.title
    self.make_valid(shop.link_lists)
  end
end

class Link < ActiveRecord::Base
  belongs_to :link_list
  acts_as_list scope: :link_list
  attr_accessible :title, :link_type, :subject_handle, :subject_params, :url

  before_save do
    self.title = self.title.blank? ? '未命名' : self.title
  end
end
