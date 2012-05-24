class ApiClient < ActiveRecord::Base
  belongs_to :shop
  validates_uniqueness_of :api_key
  attr_accessible []

  before_create do
    self.password      ||= SecureRandom.hex(16)
    self.shared_secret ||= SecureRandom.hex(16)
    self.api_key       ||= SecureRandom.hex(16)
    self.title         ||= shop.api_clients.blank? ?  "tool - 1" : shop.api_clients.last.title.succ
  end
end
