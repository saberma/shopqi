#encoding: utf-8
require 'spec_helper'

describe Shop::OrderController do

  let(:shop) { Factory(:user).shop }

  context '#address' do

    let(:billing_address_attributes) { {name: 'ma', province: 'guandong', city: 'shenzhen', address1: '311', phone: '13912345678' } }

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
        get :address, shop_id: shop.id
        post :create, shop_id: shop.id, order: {
          email: 'mahb45@gmail.com',
          billing_address_attributes: {
            name: 'ma', province: 'guandong', city: 'shenzhen', address1: '311', phone: '13912345678'
          }
        }
        get :pay, shop_id: shop.id
        post :create, shop_id: shop.id, order: { shipping_rate: '1', gateway: '1' }
        order = assigns['_resources']['order']
        order.shipping_rate.should eql '1'
        order.gateway.should eql '1'
      end.should change(Order, :count).by(1)
    end

  end

end
