require "spec_helper"

describe ShopMailer do
  let(:theme) { Factory :theme_woodland_dark }
  let(:shop) do
    model = Factory(:user).shop
    model.themes.install theme
    model.update_attributes password_enabled: false
    model
  end
  let(:iphone4) { Factory :iphone4, shop: shop }
  let(:variant) { iphone4.variants.first }
  let(:cart) { Factory :cart, shop: shop, cart_hash: %Q({"#{variant.id}":1}) }
  let(:order) do
    o = Factory.build :order, shop: shop
    o.line_items.build product_variant: variant, price: variant.price, quantity: 1
    o.save
    o
  end
  it "should be send order email" do
    with_resque do
      order.send_email('order_confirm')
      ActionMailer::Base.deliveries.empty?.should be_false
    end
  end
end
