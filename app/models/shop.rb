# encoding: utf-8
class Shop < ActiveRecord::Base
  has_many :users
  
  #二级域名须为3到20位数字和字母组成的，且唯一
  validates :permanent_domain,:presence =>true,:uniqueness => true, :format => {:with => /\A([a-z0-9])*\Z/ },:length => 3..20
  
  before_create :init_valid_date
  
  protected
  def init_valid_date
    self.deadline = Date.today.next_day(10)
  end
  
  def available?
    !self.deadline.past?
  end
end
