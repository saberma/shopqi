# encoding: utf-8
class LinkList < ActiveRecord::Base
  has_many :links, :dependent => :destroy
end
