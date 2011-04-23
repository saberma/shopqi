# encoding: utf-8
class Link < ActiveRecord::Base
  belongs_to :link_list

  default_scope :order => 'position asc'
end
