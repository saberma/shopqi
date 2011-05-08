# encoding: utf-8
class LinkList < ActiveRecord::Base
  belongs_to :shop
  has_many :links, dependent: :destroy

  accepts_nested_attributes_for :links
end

class Link < ActiveRecord::Base
  belongs_to :link_list

  default_scope order: 'position asc'
end
