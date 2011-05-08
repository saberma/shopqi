# encoding: utf-8
class Product < ActiveRecord::Base
  belongs_to :shop
  has_many :photos, dependent: :destroy 

  accepts_nested_attributes_for :photos, allow_destroy: true
end
