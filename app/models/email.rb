class Email < ActiveRecord::Base
  belongs_to :shop
  attr_accessible :title, :mail_type, :body, :include_html, :body_html

  def content # 判断用text/plain模版还是html模版
    self.include_html ? self.body_html : self.body
  end

  def content_type
    self.include_html ? 'text/html' : 'text/plain'
  end
end
