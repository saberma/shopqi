# encoding: utf-8
class Discount < ActiveRecord::Base
  belongs_to :shop

  before_save do
    self.code = self.code.blank? ? self.class.generate_code : self.code
    self.value ||= 5
  end

  def self.generate_code # 8位随机码
    o = [(0..9),('A'..'Z')].map{|i| i.to_a}.flatten
    (1..8).map{ o[rand(o.length)]  }.join
  end
end
