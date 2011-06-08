#encoding: utf-8
require 'spec_helper'

describe Shop::OrderController do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  context '(without products)' do

    context '#address' do

      it 'should be error' do
        get :address, shop_id: shop.id
        assigns['_resources'].should be_nil
      end

    end

    context '#pay' do

      it 'should be error' do
        get :pay, shop_id: shop.id
        assigns['_resources'].should be_nil
      end

    end

    context '#create' do

      it 'should be error' do
        post :create, shop_id: shop.id, billing_is_shipping: true, order: {
          email: 'mahb45@gmail.com',
        }
        assigns['_resources'].should be_nil
      end

    end

  end

  context '(with products)' do

    let(:billing_address_attributes) { {name: 'ma', province: 'guandong', city: 'shenzhen', district: 'nanshan', address1: '311', phone: '13912345678' } }

    before :each do
      @cookies = mock('cookies')
      @cookies.stub!(:[], 'cart').and_return("#{variant.id}|1")
      controller.stub!(:cookies).and_return(@cookies)
    end

    context '#address' do

      before :each do
        get :address, shop_id: shop.id #初始化cookie
      end

      it 'should copy the billding address' do
        post :create, shop_id: shop.id, billing_is_shipping: true, order: {
          email: 'mahb45@gmail.com',
          billing_address_attributes: billing_address_attributes
        }
        order = assigns['_resources']['order']
        order.shipping_address.name.should eql order.billing_address.name
        order.shipping_address.address1.should eql order.billing_address.address1
      end

      it 'should go to pay' do
        post :create, shop_id: shop.id, order: {
          email: 'mahb45@gmail.com',
          billing_address_attributes: billing_address_attributes
        }
        response.should be_success
      end

    end

    context '#create' do

      it 'should be save' do
        expect do
          order_attrs = {
            email: 'mahb45@gmail.com',
            billing_address_attributes: billing_address_attributes
          }
          get :address, shop_id: shop.id
          post :create, shop_id: shop.id, order: order_attrs
          @session = mock('session')
          @session.should_receive(:[]).with(:order_params).at_least(:once).and_return(order_attrs)
          @session.should_receive(:[]).with(:order_step).at_least(:once).and_return('pay')
          @session.should_receive(:[]=).at_least(:once)
          controller.stub!(:session).and_return(@session)
          get :pay, shop_id: shop.id
          post :create, shop_id: shop.id, order: { shipping_rate: '1', gateway: '1' }
          order = assigns['_resources']['order']
          order.errors.should be_empty
          order.shipping_rate.should eql '1'
          order.gateway.should eql '1'
        end.should change(Order, :count).by(1)
      end

    end

  end

end
