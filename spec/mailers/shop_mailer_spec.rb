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

  describe OrderTransaction do

    let(:transaction) { order.transactions.create kind: :capture }

    let(:payment) { Factory :payment_alipay, shop: shop }

    describe 'customer' do # 顾客

      it "should receive paid email" do # 能收到支付成功通知邮件
        email = ShopMailer.paid(transaction.id).deliver
        email.subject.should eql "订单 #1001 完成支付\n"
        email.body.should include('尊敬的马海波')
        email.body.should include('您好，我们已经收到您通过 在线支付-支付宝 支付的款项 ¥3010.0 元。')
      end

    end

    describe 'subscribers' do # 商店管理员订阅者

      it "should receive paid email" do # 能收到支付成功通知邮件
        email = ShopMailer.paid_notify(transaction.id).deliver
        email.subject.should eql "[测试商店] 订单 #1001 , 马海波完成支付\n"
        email.body.should include('马海波 通过 在线支付-支付宝 成功支付款项 ¥3010.0 元。')
      end

    end

  end

end
