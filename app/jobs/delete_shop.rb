module DeleteShop
  @queue = "delete_shop"

  def self.perform(id)
    shop = Shop.find(id)
    shop.destroy
  end
end
