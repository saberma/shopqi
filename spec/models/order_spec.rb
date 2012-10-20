#encoding: utf-8
require 'spec_helper'

describe Order do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  let(:payment) { Factory :payment, shop: shop }

  let(:order) do
    o = Factory.build(:order, shop: shop, email: 'admin@shopqi.com', shipping_rate: '普通快递-10.0', payment_id: payment.id)
    o.line_items.build product_variant: variant, price: 10, quantity: 2
    o.save
    o
  end

  let(:line_item) { order.line_items.first }

  describe Customer do

    it 'should be add' do
      shop
      expect do
        expect do
          order
        end.to change(Customer, :count).by(1)
      end.to change(CustomerAddress, :count).by(1)
      order.customer.should_not be_nil
    end

  end

  describe OrderTransaction do

    let(:transaction) { order.transactions.create kind: :capture }

    context 'capture' do # 支付

      it 'should be add' do
        expect do
          transaction
        end.to change(OrderTransaction, :count).by(1)
      end

      it 'should save history' do
        order
        expect do
          transaction
        end.to change(OrderHistory, :count).by(1)
      end

      context 'enough amount' do # 完整支付

        it 'should change order financial_status to paid' do
          transaction
          order.reload.financial_status_paid?.should be_true
        end

      end

      context 'no enough amount' do # 部分支付

        let(:transaction) { order.transactions.create kind: :capture, amount: 1 }

        it 'should not change order financial_status' do
          transaction
          order.reload.financial_status_paid?.should_not be_true
        end

      end

    end

    describe 'email' do

      before { order; ActionMailer::Base.deliveries.clear }

      context '#create' do

        it 'should send email' do # 给顾客、管理员发送通知邮件
          with_resque do
            ActionMailer::Base.deliveries.empty?.should be_true
            transaction
            ActionMailer::Base.deliveries.empty?.should be_false
            email = ActionMailer::Base.deliveries.first # 顾客
            email.subject.should eql "订单 #1001 完成支付\n"
            email = ActionMailer::Base.deliveries.last # 管理员
            email.subject.should eql "[测试商店] 订单 #1001 , 马海波完成支付\n"
          end
        end

      end

    end

  end

  describe OrderLineItem do

    it 'should set variant attributes' do
      line_item.title.should eql iphone4.title
      line_item.variant_title.should be_nil
      line_item.name.should eql variant.name
      line_item.vendor.should eql iphone4.vendor
      line_item.requires_shipping.should eql variant.requires_shipping
      line_item.grams.should eql (variant.weight * 1000).to_i
      line_item.sku.should eql variant.sku
    end

  end

  describe OrderFulfillment do

    let(:fulfillment) do
      record = order.fulfillments.build notify_customer: 'true'
      record.line_items << line_item
      record.save
      record
    end

    it 'should be add' do
      expect do
        fulfillment
      end.to change(OrderFulfillment, :count).by(1)
      line_item.reload.fulfilled.should be_true
      order.reload.fulfillment_status.should eql 'fulfilled'
    end

    it 'should save history' do
      order
      expect do
        fulfillment
        order.histories.first.url.should_not be_blank
      end.to change(OrderHistory, :count).by(1)
    end

    describe 'email' do

      before { ActionMailer::Base.deliveries.clear }

      context '#create' do

        it 'should send email to customer' do # 给顾客发送发货通知邮件
          with_resque do
            ActionMailer::Base.deliveries.empty?.should be_true
            fulfillment
            ActionMailer::Base.deliveries.empty?.should be_false
            email = ActionMailer::Base.deliveries.last
            email.subject.should eql "订单 #1001 发货提醒\n"
          end
        end

      end

      context '#update' do

        it 'should send email to customer' do # 给顾客发送发货更新邮件
          with_resque do
            fulfillment
            fulfillment.update_attributes! tracking_number: 'abcd1234' # 更新属性并保存，此时发邮件
            fulfillment.save # 未做任何修改时保存，不要发邮件
            ActionMailer::Base.deliveries.size.should eql 4 # 下单成功、下单通知、发货通知、发货修改
            email = ActionMailer::Base.deliveries.last
            email.subject.should eql "订单 #1001 运送方式更改提醒\n"
          end
        end

      end

    end

    describe 'alipay' do # 集成支付宝(担保交易发货接口，即时到帐退款接口)

      let(:trade_no) { '2012041441700373' } # 支付宝交易号

      context 'goods' do # 发货

        let(:payment) { Factory :payment_alipay_escrow, shop: shop } # 支付方式:支付宝

        let(:fulfillment) do
          record = order.fulfillments.build notify_customer: 'true', tracking_number: 'abcd1234', tracking_company: '申通E物流'
          record.line_items << line_item
          record.save
          record
        end

        before do
          order.trade_no = trade_no
          order.save
        end

        it 'should receive send goods' do # 接受到发货信息
          options = { 'logistics_name' => '申通E物流', 'invoice_no' => 'abcd1234', 'trade_no' => trade_no }
          Gateway::Alipay::Goods.should_receive(:send).with(options, payment.account, payment.key, payment.email)
          with_resque do
            fulfillment
          end
        end

      end

      context 'refund' do # 退款

        let(:payment) { Factory :payment_alipay, shop: shop } # 支付方式:支付宝即时到帐

        let(:transaction) { order.refund! }

        it 'should be add' do
          expect do
            transaction.status.to_sym.should eql :pending
          end.to change(OrderTransaction, :count).by(1)
        end

        context 'with pending refund' do

          before { transaction }

          it 'should be query' do # 等待退款
            order.transactions.pending_refund.first.should_not be_nil
          end

        end


        context 'without pending refund' do

          it 'should be query' do # 无须退款
            order.transactions.pending_refund.first.should be_nil
          end

        end

      end

    end

  end

  describe 'validate' do # 校验

    let(:order) do
      o = shop.orders.build
      o.line_items.build product_variant: variant, price: 10, quantity: 2
      o
    end

    it 'should be perform' do
      order.valid?.should be_false
      order.errors[:email].should_not be_empty
      order.errors[:shipping_rate].should_not be_empty
      order.errors[:payment_id].should_not be_empty
    end

    it 'should validate shipping_address' do
      order.update_attributes email: 'mahb45@gmail.com', shipping_address_attributes: { name: '' }
      order.errors['shipping_address.name'].should_not be_empty
    end

    context 'free order' do # 免费订单

      let(:free_shipping_rate){ shop.shippings.first.weight_based_shipping_rates.create name: '免费快递', price: 0 } # 全国免运费

      before { free_shipping_rate }

      context 'without discount' do # 没有优惠码

        let(:free_order) do
          o = Factory.build(:order, shop: shop, email: 'admin@shopqi.com', shipping_rate: '免费快递-0.0')
          o.line_items.build product_variant: variant, price: 0, quantity: 1
          o.save
          o
        end

        it 'should not validate payment' do # 不需要支付
          free_order.total_price.should be_zero
          free_order.errors.should be_empty
          free_order.financial_status_paid?.should be_true
        end

      end

      context 'discount' do # 使用了优惠码

        let(:discount) { shop.discounts.create code: 'coupon123', value: 20 }

        let(:order) do
          o = Factory.build(:order, shop: shop, email: 'admin@shopqi.com', shipping_rate: '免费快递-0.0', discount_code: discount.code)
          o.line_items.build product_variant: variant, price: 10, quantity: 1
          o.save
          o
        end

        it 'should not validate payment' do # 不需要支付
          order.total_price.should be_zero
          order.errors.should be_empty
          order.financial_status_paid?.should be_true
        end

      end

    end

    #it 'should validate shipping_rate' do # 商店要支持的配送方式
    #  order.update_attributes email: 'mahb45@gmail.com', shipping_rate: "顺丰快递-0"
    #  order.errors['shipping_rate'].should_not be_empty
    #end

  end

  describe 'create' do

    it 'should save total_price' do
      order.subtotal_price.should eql 20.0
      order.total_price.should eql 30.0
    end

    it 'should save address' do
      expect do
        expect do
          order
        end.to change(Order, :count).by(1)
      end.to change(OrderShippingAddress, :count).by(1)
    end

    it 'should save name' do
      order.number.should eql 1
      order.order_number.should eql 1001
      order.name.should eql '#1001'
    end

    it 'should save history' do
      expect do
        order
      end.to change(OrderHistory, :count).by(1)
    end

    context 'inventory tracking' do # 跟踪库存

      before do
        variant.update_attributes inventory_management: 'shopqi', inventory_quantity: 2
      end

      it 'should reduce product variant inventory quantity' do # 库存为 2，订单买了 2 件商品，库存要更新为 0
        order.save
        variant.reload.inventory_quantity.should eql 0
      end

    end

  end

  describe 'update' do

    it 'should validate gateway' do
      order.save
      order.errors[:gateway].should_not be_nil
    end

    context 'cancel' do # 取消订单

      context 'inventory tracking' do # 跟踪库存

        before do
          order
          variant.update_attributes inventory_management: 'shopqi', inventory_quantity: 0
        end

        it 'should reduce product variant inventory quantity' do # 当前库存为 0，订单包含 2 件商品，库存要更新为 2
          order.cancel_reason = 'customer' # 顾客取消订单
          order.cancel!
          variant.reload.inventory_quantity.should eql 2
        end

      end

    end

  end

  describe 'scope contain date' do

    before { order }

    it 'should be execute every time' do # 444
      shop.orders.today.size.should eql 1
      Date.stub(:today).and_return(Date.tomorrow) # 明天的统计不包含今天的订单
      shop.orders.today.size.should eql 0
    end

  end

end
