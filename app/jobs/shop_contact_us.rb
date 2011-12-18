# encoding: utf-8
module ShopContactUs

  @queue = "shop_contact_us"

  def self.perform(email, body, name, shop_id)
    ShopMailer.contact_us(email, body, name, shop_id).deliver
  end

end
