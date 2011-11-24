module DeleteShop
  @queue = "delete_shop"

  def self.perform(id)
    shop = Shop.find_by_id(id)
    shop.destroy if shop && !shop.access_enabled  #若商店不存在，或者商店已经恢复使用，则不删除
  end
end
