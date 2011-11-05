class ApiClient < ActiveRecord::Base
  belongs_to :shop
  validates_uniqueness_of :api_key

  before_create do
    #TODO :修改密钥，key生成方式
    self.password      = ActiveSupport::SecureRandom.hex(32)
    self.shared_secret = ActiveSupport::SecureRandom.hex(32)
    self.api_key       = ActiveSupport::SecureRandom.hex(32)
    self.title         = shop.api_clients.blank? ?  "tool - 1" : shop.api_clients.last.title.succ
  end
end
