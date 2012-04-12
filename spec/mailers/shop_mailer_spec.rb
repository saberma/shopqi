#encoding: utf-8
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
  let(:payment) { Factory :payment, shop: shop }
  let(:order) do
    o = Factory.build(:order, shop: shop, email: 'admin@shopqi.com', shipping_rate: '普通快递-10.0', payment_id: payment.id)
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

  describe OrderFulfillment do

    let(:fulfillment) do
      record = order.fulfillments.build notify_customer: 'true', tracking_number: 'ab12', tracking_company: '申通E物流'
      record.line_items << order.line_items.first
      record.save
      record
    end

    it "should be send ship confirm email" do # 给顾客发送发货通知邮件
      email = ShopMailer.ship('ship_confirm', fulfillment.id).deliver
      email.subject.should eql "订单 #1001 发货提醒\n"
      email.body.should include('iphone4')
      email.body.should include('ab12')
      email.body.should include('sto.cn')
    end

  end

end
