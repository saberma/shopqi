class ApiClient < ActiveRecord::Base
  belongs_to :shop
  validates_uniqueness_of :api_key

  before_create do
    #TODO :修改密钥，key生成方式
    self.password      = UUID.generate(:compact)
    self.shared_secret = UUID.generate(:compact)
    self.api_key       = UUID.generate(:compact)
    self.title         = shop.api_clients.blank? ?  "tool - 1" : shop.api_clients.last.title.succ
  end
end
