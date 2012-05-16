#encoding: utf-8
require 'spec_helper'

describe Shop::OrderController do

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

  let(:discount) { shop.discounts.create code: 'coupon123' }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  context '#new' do # 显示表单

    context 'exist vairant' do # 款式仍然存在

      it 'should be show' do
        get :new, cart_token: cart.token
        response.should be_success
      end

    end

    context 'missing variant'do # 款式已在后台管理中删除

      render_views # 让rspec渲染视图,以便检查页面显示結果

      let(:un_exist_variant_id) { 8888 }

      it 'should be show' do
        invalid_cart = Factory :cart, shop: shop, cart_hash: %Q({"#{un_exist_variant_id}":1})
        expect do
          get :new, cart_token: invalid_cart.token
        end.should_not raise_error
        response.should be_success
        response.body.should include '购物车是空的'
      end

    end

    it 'should get shipping_rates' do # 可以获取快递费用记录
      get :shipping_rates, cart_token: cart.token, code: '440305' # 深圳
      json = JSON(response.body).first['weight_based_shipping_rate']
      json['name'].should eql '普通快递'
      json['price'].should eql 10.0
    end

    context 'discount' do # 优惠码

      it 'should be apply' do # 可以使用
        post :apply_discount, cart_token: cart.token, code: discount.code
        json = JSON(response.body)
        json['code'].should eql discount.code
        json['amount'].should eql 5.0
      end

    end

  end

  context '#create' do # 创建表单(ajax操作)

    let(:payment) { Factory :payment, shop: shop }

    let(:shipping_address_attributes) { {name: 'ma', province: 'guandong', city: 'shenzhen', district: 'nanshan', address1: '311', phone: '13912345678' } }

    let(:order_attributes) { { email: 'mahb45@gmail.com', shipping_address_attributes: shipping_address_attributes, shipping_rate: '普通快递-10.0', payment_id: payment.id } }

    context 'exist vairant' do # 款式仍然存在

      it 'should be success' do
        expect do
          expect do
            post :create, cart_token: cart.token, order: order_attributes
            response.should be_success
            order = assigns['_resources']['order']
            order.errors.should be_empty
            order.shipping_address.address1.should eql shipping_address_attributes[:address1]
            order.shipping_rate.should eql '普通快递-10.0'
            order.payment_id.should eql payment.id
            order.line_items.should_not be_empty
          end.should change(Order, :count).by(1)
        end.should change(OrderLineItem, :count).by(1)
      end

      describe '#cart' do # 购物车

        before { cart }

        it 'should be destroy' do # 会被删除
          expect do
            post :create, cart_token: cart.token, order: order_attributes
          end.should change(Cart, :count).by(-1)
        end

      end

    end

    context 'missing variant' do # 款式已在后台管理中删除

      render_views # 让rspec渲染视图,以便检查页面显示結果

      let(:un_exist_variant_id) { 8888 }

      it 'should not be success' do
        invalid_cart = Factory :cart, shop: shop, cart_hash: %Q({"#{un_exist_variant_id}":1})
        expect do
          expect do
            expect do
              post :create, cart_token: invalid_cart.token, order: order_attributes
              response.should be_success
              JSON(response.body)['error'].should eql 'unavailable_product'
            end.should_not change(Order, :count)
          end.should_not change(OrderLineItem, :count)
        end.should_not change(Cart, :count)
      end

    end

    context 'discount' do # 优惠码

      before :each do
        session = mock('session')
        session.stub!(:[], 'discount_code').and_return(discount.code)
        controller.stub!(:session).and_return(session)
      end

      it 'should be use' do # 可以使用
        discount.used_times.should eql 0
        expect do
          post :create, cart_token: cart.token, order: order_attributes
          order = assigns['_resources']['order']
          order.total_price.should eql (cart.total_price - discount.value + order.shipping_rate_price)
          discount.reload.used_times.should eql 1
        end.should change(OrderDiscount, :count).by(1)
      end

    end

  end

  context 'online pay' do # 在线支付

    let(:payment_alipay) { Factory :payment_alipay, shop: shop } # 支付方式:支付宝

    let(:payment_tenpay) { Factory :payment_tenpay, shop: shop } # 支付方式:财付通

    let(:order) do
      o = Factory.build :order, shop: shop, shipping_rate: '普通快递-10.0', payment_id: payment_alipay.id
      o.line_items.build product_variant: variant, price: variant.price, quantity: 1
      o.save
      o
    end

    context 'alipay' do # 支付宝

      let(:trade_no) { '2012041441700373' }

      context '#notify' do # 支付宝从后台发送通过

        before do
          controller.stub!(:valid?) { true } # 向支付宝校验notification的合法性
        end

        context 'trade status is TRADE_FINISHED' do # 交易完成(即时付款)

          let(:attrs) { { trade_no: trade_no, out_trade_no: order.token, notify_id: '123456', trade_status: 'TRADE_FINISHED', total_fee: order.total_price } }

          it 'should change order financial_status to paid' do
            order.financial_status_pending?.should be_true
            expect do
              post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
              response.body.should eql 'success'
              order.reload.financial_status_paid?.should be_true
            end.should change(OrderTransaction, :count).by(1)
            order.transactions.first.amount.should eql order.total_price
            order.trade_no.should eql trade_no
          end

          it 'should be retry' do # 要支持重复请求
            order.financial_status = :abandoned
            order.save
            post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
            response.body.should eql 'success'
            post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
            response.body.should eql 'success'
            order.reload.financial_status.to_sym.should eql :abandoned # 不能再次被修改为paid
          end

        end

        context 'trade status is WAIT_SELLER_SEND_GOODS' do # 已付款，等待卖家发货(担保交易)

          let(:attrs) { { trade_no: trade_no, out_trade_no: order.token, notify_id: '123456', trade_status: 'WAIT_SELLER_SEND_GOODS', total_fee: order.total_price } }

          it 'should change order financial_status to paid' do
            order.financial_status_pending?.should be_true
            expect do
              post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
              response.body.should eql 'success'
              order.reload.financial_status_paid?.should be_true
            end.should change(OrderTransaction, :count).by(1)
            order.transactions.first.amount.should eql order.total_price
            order.trade_no.should eql trade_no
          end

        end

        context 'trade status is WAIT_BUYER_PAY' do # 等待顾客付款

          let(:attrs) { { out_trade_no: order.token, notify_id: '123456', trade_status: 'WAIT_BUYER_PAY', total_fee: order.total_price } }

          it 'should remain order financial status' do
            order.financial_status_pending?.should be_true
            post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
            response.body.should eql 'success'
            order.reload.financial_status_pending?.should be_true
          end

        end

      end

      context '#done' do # 支付宝直接跳转回商店(支付成功后才会返回)

        before do
          order.payment = payment_alipay
          order.save
        end

        context 'trade status is TRADE_SUCCESS' do # 交易完成

          let(:attrs) { { trade_no: trade_no, out_trade_no: order.token, trade_status: 'TRADE_SUCCESS', total_fee: order.total_price } }

          it 'should change order financial_status to paid' do
            expect do
              get :done, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
              response.should be_success
            end.should change(OrderTransaction, :count)
            order.reload.financial_status_paid?.should be_true
            order.trade_no.should eql trade_no
          end

          it 'should be retry' do # 要支持重复请求
            order.financial_status = :abandoned
            order.save
            get :done, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
            response.should be_success
            expect do
              get :done, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
              response.should be_success
            end.should_not change(OrderTransaction, :count)
            order.reload.financial_status.to_sym.should eql :abandoned # 不能再次被修改为paid
          end

        end

      end

    end

    context 'tenpay' do # 财付通

      let(:date) { Date.today.to_s(:number) }

      let(:transaction_id) { "#{order.payment.account}#{date}0000000001" }

      let(:attrs) { { cmdno: '1', pay_result: '0', date: Date.today.to_s(:number), transaction_id: transaction_id, sp_billno: order.token, total_fee: (order.total_price*100).to_i, fee_type: '1', attach: 'ShopQi' } }

      before do
        order.payment_id = payment_tenpay.id
        order.save
      end

      context '#notify' do # 财付通从后台发送通过

        context 'trade status is TRADE_FINISHED' do # 交易完成

          it 'should change order financial_status to paid' do
            order.financial_status_pending?.should be_true
            expect do
              post :tenpay_notify, attrs.merge(bargainor_id: order.payment.account, sign: tenpay_sign(attrs, order.payment.key))
              response.body.should_not eql 'fail'
              order.reload.financial_status_paid?.should be_true
            end.should change(OrderTransaction, :count).by(1)
            order.transactions.first.amount.should eql order.total_price
          end

          it 'should be retry' do # 要支持重复请求
            order.reload
            order.financial_status = :abandoned
            order.save
            post :tenpay_notify, attrs.merge(bargainor_id: order.payment.account, sign: tenpay_sign(attrs, order.payment.key))
            response.body.should_not eql 'fail'
            post :tenpay_notify, attrs.merge(bargainor_id: order.payment.account, sign: tenpay_sign(attrs, order.payment.key))
            response.body.should_not eql 'fail'
            order.reload.financial_status.to_sym.should eql :abandoned # 不能再次被修改为paid
          end

        end

      end

      context '#done' do # 财付通直接跳转回商店(支付成功后才会返回)

        it 'should change order financial_status to paid' do
          get :tenpay_done, attrs.merge(token: order.token, sign: sign(attrs, order.payment.key))
          response.should be_success
        end

      end

    end

  end

end

def tenpay_sign(attrs, key) # 财付通传递url参数时的加密字符串
  md5_string = attrs.map {|s| "#{s[0]}=#{s[1]}"}
  Digest::MD5.hexdigest(md5_string.join("&") + "&key=#{key}")
end
