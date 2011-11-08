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

      it 'should be destroy', focus: true do # 购物车会被删除
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

end
