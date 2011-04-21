# encoding: utf-8
class LinkList < ActiveRecord::Base
  has_many :links, :dependent => :destroy

  accepts_nested_attributes_for :links
end
