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

  let(:order) do
    o = Factory.build :order, shop: shop
    o.line_items.build product_variant: variant, price: variant.price, quantity: 1
    o.save
    o
  end

  let(:payment) do # 支付方式
    Factory :payment, shop: shop
  end

  let(:payment_alipay) do # 支付方式:支付宝
    Factory :payment_alipay, shop: shop
  end

  let(:shipping_address_attributes) { {name: 'ma',country_code: 'CN', province: 'guandong', city: 'shenzhen', district: 'nanshan', address1: '311', phone: '13912345678' } }

  context '#address' do

    context 'exist vairant' do # 款式仍然存在

      it 'should be show' do
        get :address, shop_id: shop.id, cart_token: cart.token
        response.should be_success
      end

      it 'should save the shipping address' do
        expect do
          post :create, shop_id: shop.id, cart_token: cart.token, order: {
            email: 'mahb45@gmail.com',
            shipping_address_attributes: shipping_address_attributes
          }
          order = assigns['_resources']['order']
          order.shipping_address.address1.should eql order.shipping_address.address1
          order.line_items.should_not be_empty
        end.should change(Order, :count).by(1)
      end

    end

    context 'missing variant' do # 款式已在后台管理中删除

      render_views

      let(:un_exist_variant_id) { 8888 }

      it 'should be show' do
        invalid_cart = Factory :cart, shop: shop, cart_hash: %Q({"#{un_exist_variant_id}":1})
        expect do
          get :address, shop_id: shop.id, cart_token: invalid_cart.token
        end.should_not raise_error
        response.should be_success
      end

    end

  end

  context '#update' do
    it 'should be pay' do
      get :pay, shop_id: shop.id, token: order.token
      response.should be_success
    end

    it 'should update financial_status' do
      #china
      post :commit, shop_id: shop.id, token: order.token, order: { shipping_rate: '普通快递-10.0', payment_id: payment.id }
      order.reload.financial_status.should eql 'pending'
    end

    it 'should show product line_items' do
      #china
      order
      expect do
        post :commit, shop_id: shop.id, token: order.token, order: { shipping_rate: '普通快递-10.0', payment_id: payment.id }
        order = assigns['_resources']['order']
        order.errors.should be_empty
        order.shipping_rate.should eql '普通快递-10.0'
        order.payment_id.should eql payment.id
      end.should_not change(Order, :count)
    end

  end

  context '#commit' do # 提交订单

    describe '#cart' do

      it 'should be destroy' do # 购物车会被删除
        post :create, shop_id: shop.id, cart_token: cart.token, order: {
          email: 'mahb45@gmail.com',
          shipping_address_attributes: shipping_address_attributes
        }
        expect do
          post :commit, shop_id: shop.id, token: cart.token, order: { shipping_rate: '普通快递-10.0', payment_id: payment.id }
        end.should change(Cart, :count).by(-1)
      end

    end

  end

  context '#notify' do # 支付宝从后台发送通过

    before do
      post :commit, shop_id: shop.id, token: order.token, order: { shipping_rate: '普通快递-10.0', payment_id: payment_alipay.id }
      order.reload
      controller.stub!(:valid?) { true } # 向支付宝校验notification的合法性
    end

    context 'trade status is TRADE_FINISHED' do # 交易完成

      let(:attrs) { { out_trade_no: order.token, notify_id: '123456', trade_status: 'TRADE_FINISHED', total_fee: order.total_price } }

      it 'should change order financial_status to paid' do
        order.financial_status_pending?.should be_true
        expect do
          post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
          response.body.should eql 'success'
          order.reload.financial_status_paid?.should be_true
        end.should change(OrderTransaction, :count).by(1)
        order.transactions.amount.should eql order.total_price
      end

      it 'should be retry' do # 要支持重复请求
        order.reload
        order.financial_status = :abandoned
        order.save
        post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
        response.body.should eql 'success'
        post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
        response.body.should eql 'success'
        order.reload.financial_status.to_sym.should eql :abandoned # 不能再次被修改为paid
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

  context '#done', focus: true do # 支付宝直接跳转回商店(支付成功后才会返回)

    before do
      order.financial_status = 'pending'
      order.payment = payment_alipay
      order.save
    end

    context 'trade status is TRADE_SUCCESS' do # 交易完成

      let(:attrs) { { out_trade_no: order.token, trade_status: 'TRADE_SUCCESS', total_fee: order.total_price } }

      it 'should change order financial_status to paid', f: true do
        expect do
          get :done, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
          response.should be_success
        end.should_not change(OrderTransaction, :count)
        order.reload.financial_status_paid?.should be_true
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

private
def sign(attrs, key)
  md5_string = attrs.sort.map {|s| "#{s[0]}=#{s[1]}"}
  Digest::MD5.hexdigest(md5_string.join("&") + key)
end
