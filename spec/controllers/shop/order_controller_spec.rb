#encoding: utf-8
require 'spec_helper'

describe Shop::OrderController do

  let(:shop) { Factory(:user).shop }

  context '#new' do

    describe 'validate' do

      it 'should validate billing_address' do
        post :create, shop_id: shop.id
        assigns['_resources']['order'].errors[:email].should_not be_nil
      end

      it 'should validate billing_address' do
        get :address, shop_id: shop.id
        post :create, shop_id: shop.id, order: { billing_address_attributes: { name: '' } }
        assigns['_resources']['order'].errors['billing_address.name'].should_not be_empty
      end

    end

    it 'should go to pay' do
      get :address, shop_id: shop.id
      post :create, shop_id: shop.id, order: {
        email: 'mahb45@gmail.com',
        billing_address_attributes: {
          name: 'ma', province: 'guandong', city: 'shenzhen', address1: '311', phone: '13912345678'
        }
      }
      response.should be_success
    end

  end

  context '#pay' do

    describe 'validate' do

      it 'should validate gateway' do
        get :pay, shop_id: shop.id
        post :create, shop_id: shop.id
        assigns['_resources']['order'].errors[:email].should_not be_nil
      end

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
